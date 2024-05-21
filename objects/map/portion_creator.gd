extends Node2D

@export var info:PortionInfo

var animating:bool = false

func displayNoCah():
	bop(2)
	if animating: return
	var tween = create_tween()
	$Label.modulate = Color(1,1,1,1)
	tween.tween_callback(func(): animating = true)
	tween.tween_property($Label,"modulate", Color(0,0,0,0),1).from(Color(1,1,1,1)).set_delay(1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): animating = false)

func bop(am:float, delay:float = 0.0):
	var amount:Vector2 = Vector2(am,am)
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale",amount,0.05).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).from(Vector2(1,1))
	tween.tween_property($Sprite2D,"scale",Vector2(1.5 -(am-1.5),1.5 -(am-1.5)),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D,"scale",Vector2(1.5,1.5),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func create():
	if not Global.mainGame.CheckPrices(info.cost):
		displayNoCah()
		return
	var portion = preload("res://objects/map/map_portion.tscn").instantiate()
	portion.global_position = $Point.global_position
	portion.info = info
	get_parent().add_child(portion)
	queue_free()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_released():
			create()
