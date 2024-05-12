extends Node2D
class_name Building

@export var info:BuildingInfo

var canDelete:bool = true


func _ready():
	$AllTheBuildingShit/Rect.input_event.connect(_inputter)

func _inputter(viewport:Node,event:InputEvent,shape:int):
	if event is InputEventScreenTouch:
		if event.is_released():
			pass
