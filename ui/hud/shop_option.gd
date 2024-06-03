extends Control

@export var build:BuildingRes

var selectedIcon:int = 0

func _ready():
	$TextureRect/Icon.texture = build.icon[0]
	$TextureRect/Name.text = build.name
	$TextureRect/Name2.text = build.desc


func _on_timer_timeout():
	selectedIcon += 1
	if selectedIcon >= build.icon.size():
		selectedIcon = 0
	%Icon.texture = build.icon[selectedIcon]


func pressed():
	Events.buildingChosen.emit(build)
	Global.mainGame.CloseShop()
