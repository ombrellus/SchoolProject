extends Node2D
class_name Building

@export var info:BuildingInfo

var popUp:PackedScene = preload("res://objects/utils/effects/resource_pop_up.tscn")

var portion:TileMap
var tile:Vector2i
var canDelete:bool = true

@onready var detectors:Node2D = $AllTheBuildingShit/Detectors


func _ready():
	$AllTheBuildingShit/Rect.input_event.connect(_inputter)
	if info.type != Global.BuildingType.PRODUCER:
		$AllTheBuildingShit/Detectors.queue_free()

func _inputter(viewport:Node,event:InputEvent,shape:int):
	if event is InputEventScreenTouch:
		if event.is_released():
			if Global.camera.offset != Global.camera.last_pos:
				return
			Events.buildingTouched.emit(self,info)

func Destroy():
	portion.set_cell(1,tile,portion.get_cell_source_id(1,tile),Vector2i(0,0))
	queue_free()

func DetectAroundResourceBuildings() -> Array[Price]:
	var areas:Array[Price] = []
	for dect:Area2D in detectors.get_children():
		if not dect.get_overlapping_areas().is_empty():
			var build:Building=  dect.get_overlapping_areas()[0].get_parent().get_parent()
			if build.info.type ==Global.BuildingType.RESOURCE:
				for e in build.info.resourceMaterial:
					if e.type == info.material: areas.append(e)
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
	
