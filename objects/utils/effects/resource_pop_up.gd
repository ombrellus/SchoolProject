extends Node2D

var values:Price

func _ready():
	$Node2D/Sprite2D.texture = Global.resourceIcons[values.type]
	$Node2D/Label.text = str(values.value)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Node2D,"position",Vector2(0,-10),0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Node2D,"modulate",Color(0,0,0,0),0.7).set_delay(0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free).set_delay(1.4)
