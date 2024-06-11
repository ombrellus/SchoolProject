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
	var portion = preload("res://objects/map/map_portion.tscn").instantiate()
	portion.global_position = $Point.global_position
	portion.info = info
	Events.createPortion.emit(info.cost,portion)
	get_parent().add_child(portion)
	queue_free()

func _ready():
	for i in info.cost:
		var lex = preload("res://ui/hud/powers_hud/power_price_label.tscn").instantiate()
		lex.get_node("TextureRect").texture = Global.resourceIcons[i.type]
		lex.set_meta("type",i.type)
		lex.set_meta("value",i.value)
		lex.get_node("Label").text = str(i.value)
		$Sprite2D2/ScrollContainer/VBoxContainer.add_child(lex)

func buyMenu():
	$Sprite2D2.visible = true
	$Sprite2D2/Button.modulate = Color(1,1,1,1)
	$Sprite2D2/Button/Area2D/CollisionShape2D.disabled = false
	for i in $Sprite2D2/ScrollContainer/VBoxContainer.get_children():
		if Global.mainGame.heldResources[i.get_meta("type")] < i.get_meta("value"):
			i.get_node("Label").add_theme_color_override("font_color",Color(0.875, 0.243, 0.137))
		else: i.get_node("Label").add_theme_color_override("font_color",Color(1, 1, 1))
	if not Global.mainGame.CheckPrices(info.cost):
		$Sprite2D2/Button/Area2D/CollisionShape2D.disabled = true
		$Sprite2D2/Button.modulate = Color(1,1,1,0.5)

func closeMenu():
	$Sprite2D2.visible = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_released():
			bop(1.7)
			buyMenu()


func yes_button(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_released():
			create()


func no_button(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_released():
			closeMenu()
