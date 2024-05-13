extends Node2D
class_name Building

@export var info:BuildingInfo

var portion:TileMap
var tile:Vector2i
var canDelete:bool = true


func _ready():
	$AllTheBuildingShit/Rect.input_event.connect(_inputter)
	if info.type != Global.BuildingType.PRODUCER:
		$AllTheBuildingShit/Detectors.queue_free()

func _inputter(viewport:Node,event:InputEvent,shape:int):
	if event is InputEventScreenTouch:
		if event.is_released():
			Events.buildingTouched.emit(self,info)

func Destroy():
	portion.set_cell(1,tile,portion.get_cell_source_id(1,tile),Vector2i(0,0))
	queue_free()
