extends Node2D

@export var info:PortionInfo

var animating:bool = false

func displayNoCah():
	if animating: return
	var tween = create_tween()
	$Label.modulate = Color(1,1,1,1)
	tween.tween_callback(func(): animating = true)
	tween.tween_property($Label,"modulate", Color(0,0,0,0),1).from(Color(1,1,1,1)).set_delay(1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): animating = false)

func create():
	if not Global.mainGame.CheckPrices(info.cost):
		displayNoCah()
		return
	var portion = preload("res://objects/map/map_portion.tscn").instantiate()
	portion.global_position = $Point.global_position
	portion.info = info
	get_parent().add_child(portion)
	queue_free()
