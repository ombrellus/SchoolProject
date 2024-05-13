extends Control

var icon:Texture2D
var amount:int

func update():
	$TextureRect/TextureRect2.texture = icon
	$TextureRect/Label.text = str(amount)
