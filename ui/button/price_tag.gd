extends Control

var icon:Texture2D
var amount:int
var enough:bool = true

func update():
	$TextureRect/TextureRect2.texture = icon
	$TextureRect/Label.text = str(amount)
	if not enough:
		$TextureRect/Label.add_theme_color_override("font_color",Color(0.875, 0.243, 0.137))
