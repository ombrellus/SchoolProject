extends Building

@export var newTile:Vector2i

func Destroy():
	portion.set_cell(0,tile,portion.get_cell_source_id(0,tile),newTile)
	super()
