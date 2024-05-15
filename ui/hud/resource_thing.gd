extends Control

@export var info:Price

func _ready():
	Events.updateResources.connect(_update)
	$TextureRect/TextureRect2.texture = Global.resourceIcons[info.type]
	$TextureRect/Label.text = str(info.value)

func _update(new:Price):
	if info.type != new.type: return
	info.value += new.value
	$TextureRect/TextureRect2.texture = Global.resourceIcons[info.type]
	$TextureRect/Label.text = str(info.value)
