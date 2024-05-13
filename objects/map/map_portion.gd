extends TileMap

@export var noise:FastNoiseLite = FastNoiseLite.new()

func _ready():
	_generate()

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_released():
			var pos = get_local_mouse_position()
			var tile_pos = local_to_map(pos)
			var data = get_cell_tile_data(0,tile_pos)
			var truePos = map_to_local(tile_pos)
			if data == null:
				return
			if get_cell_tile_data(1,tile_pos).get_custom_data("used") == false:
				Events.tryPlacing.emit(truePos,tile_pos,data.get_custom_data("type"),self)

func _generate():
	noise.seed = randi()
	for x in 9:
		for y in 9:
			var sea = noise.get_noise_2d(x,y)
			print(str(x)+","+str(y)+" "+str(sea))
			if sea >= 0.17:
				set_cell(0,Vector2i(x,y),get_cell_source_id(0,Vector2i(x,y)),Vector2i(3,0))
			elif not sea <=0.04:
				set_cell(0,Vector2i(x,y),get_cell_source_id(0,Vector2i(x,y)),Vector2i(2,0))
