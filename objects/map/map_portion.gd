extends TileMap

@export var noise:FastNoiseLite = FastNoiseLite.new()

@export var hasRocks:bool = true

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
				SetTilesAround(Vector2i(x,y),Vector2i(2,0))
	GenerateDet(preload("res://objects/building/res/tree.tres"),Vector2i(6,12))
	if hasRocks:
		GenerateDet(preload("res://objects/building/res/rock.tres"),Vector2i(3,5))

func GenerateDet(build:BuildingRes,ra:Vector2i):
	var cells:Array[Vector2i]
	for i in get_used_cells(0):
		if get_cell_tile_data(0,i).get_custom_data("tree") == true and not get_cell_tile_data(1,i).get_custom_data("used") == true:
			cells.append(i)
	for i in randi_range(ra.x,ra.y):
		var tile = cells.pick_random()
		spawnBuilding(tile,build)
		cells.remove_at(cells.find(tile))
		

func spawnBuilding(tile:Vector2i,sex:BuildingRes):
	var build:Building = sex.packed.instantiate()
	build.position = map_to_local(tile)
	build.portion = self
	build.tile = tile
	add_child(build)
	build.get_node("Sprite2D").texture = sex.icon.pick_random()
	set_cell(1,tile,get_cell_source_id(1,tile),Vector2i(1,0))

func SetTilesAround(pos:Vector2i,tile:Vector2i):
	for c in get_surrounding_cells(pos):
		var id = get_cell_source_id(0,c)
		print(id)
		if id != -1 and get_cell_atlas_coords(0,c) != Vector2i(3,0):
			set_cell(0,c,id,tile)
