extends Control

@export var value:int = 0
@export var type:Global.Resources

func _ready():
	Events.updateResources.connect(_update)
	$TextureRect/TextureRect2.texture = Global.resourceIcons[type]
	$TextureRect/Label.text = str(value)

func _update(new:Price):
	if type != new.type: return
	value += new.value
	$TextureRect/TextureRect2.texture = Global.resourceIcons[type]
	$TextureRect/Label.text = str(value)
