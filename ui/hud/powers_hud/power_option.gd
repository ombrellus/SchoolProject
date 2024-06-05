extends Control

@export var power:PowerRes


func _ready():
	$TextureRect/Icon.texture = power.icon
	$TextureRect/Name.text = power.name
	$TextureRect/Name2.text = power.desc



func pressed():
	Global.mainGame.OpenConfirmPowerBuy(self)
