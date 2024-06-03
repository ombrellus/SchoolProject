extends Node2D
class_name Building

@export var info:BuildingInfo

var popUp:PackedScene = preload("res://objects/utils/effects/resource_pop_up.tscn")

var portion:TileMap
var spawnNum:int = 0
var tile:Vector2i
var canDelete:bool = true

@onready var detectors:Node2D = $AllTheBuildingShit/Detectors


func _ready():
	$AllTheBuildingShit/Rect.input_event.connect(_inputter)
	if info.type != Global.BuildingType.PRODUCER:
		$AllTheBuildingShit/Detectors.queue_free()
	bop(1.2,spawnNum)

func _inputter(viewport:Node,event:InputEvent,shape:int):
	if event is InputEventScreenTouch:
		if event.is_released():
			if Global.camera.offset != Global.camera.last_pos:
				return
			Events.buildingTouched.emit(self,info)
			bop(1.2)

func Destroy():
	portion.set_cell(1,tile,portion.get_cell_source_id(1,tile),Vector2i(0,0))
	queue_free()

func DetectAroundResourceBuildings(type:Global.Resources) -> Array[Price]:
	var areas:Array[Price] = []
	var hehe = detectors.get_children()
	if hehe.is_empty(): return []
	for dect:Area2D in hehe:
		if not dect.get_overlapping_areas().is_empty():
			var build:Building=  dect.get_overlapping_areas()[0].get_parent().get_parent()
			if build.info.type ==Global.BuildingType.RESOURCE:
				for e in build.info.resourceMaterial:
					if type == e.type: areas.append(e)
	return areas

func GiveResources(resources:Array[Price]):
	var full:Price = Price.new()
	full.value = 0
	for i in resources:
		full.value += i.value
		full.type = i.type
	var pop = popUp.instantiate()
	pop.values = full
	pop.position = position+ Vector2(0,-8)
	Events.resourceProduced.emit(full,self)
	tallTween(Vector2(0.8,1.2))
	portion.add_child(pop)

func tallTween(amount:Vector2):
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale",amount,0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).from(Vector2(1,1))
	tween.tween_property($Sprite2D,"scale",Vector2(amount.y,amount.x),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D,"scale",Vector2(1,1),0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func bop(am:float, delay:float = 0.0):
	var amount:Vector2 = Vector2(am,am)
	if delay > 0:
		await get_tree().create_timer(delay * 0.1).timeout
	$Sprite2D.visible = true
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale",amount,0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).from(Vector2(1,1))
	tween.tween_property($Sprite2D,"scale",Vector2(1 -(am-1),1 -(am-1)),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D,"scale",Vector2(1,1),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
