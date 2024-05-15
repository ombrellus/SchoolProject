extends Camera2D

@export var zoom_speed: float = 0.1
@export var pan_speed: float = 0.5
@export var rotation_speed: float = 1.0
@export var can_pan: bool = true
@export var can_zoom: bool
@export var can_rotate: bool

var start_zoom: Vector2
var start_dist: float
var touch_points: Dictionary = {}
var start_angle: float
var current_angle: float

var last_pos:Vector2

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			last_pos = offset
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)

	if touch_points.size() < 2:
		start_dist = 0

func _handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position

	if touch_points.size() == 1 and can_pan:
		offset -= event.relative * pan_speed
