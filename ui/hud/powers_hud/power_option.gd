extends Control

@export var power:PowerRes
@export var giveBuilding:BuildingRes = null
@export var selection:Control = null


func _ready():
	$TextureRect/Icon.texture = power.icon
	$TextureRect/Name.text = power.name
	$TextureRect/Name2.text = power.desc

func Bought():
	if giveBuilding != null:
		var hehe = preload("res://ui/hud/shop_option.tscn").instantiate()
		hehe.build = giveBuilding
		selection.add_child(hehe)

func pressed():
	Global.mainGame.OpenConfirmPowerBuy(self)
