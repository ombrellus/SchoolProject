extends TileMap

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			var pos = get_local_mouse_position()
			var tile_pos = local_to_map(pos)
			var data = get_cell_tile_data(0,tile_pos)
			var truePos = map_to_local(tile_pos)
			if data.get_custom_data("used") == false:
				Events.tryPlacing.emit(truePos,data.get_custom_data("type"))
