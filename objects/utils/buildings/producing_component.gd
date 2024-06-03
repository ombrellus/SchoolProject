extends Node

@export var maxSpeed:float = 3
var speed:float = 3
@export var produces:Price
@export var neededTile:Vector2i = Vector2i(-1,-1)
@export var getResAround:bool = false
@export var resTypes:Global.Resources
@onready var root:Building = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = maxSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speed > 0:
		speed -= delta
	else:
		speed = maxSpeed
		if (neededTile == Vector2i(-1,-1) or neededTile == root.portion.get_cell_atlas_coords(0,root.tile)) and not getResAround:
			root.GiveResources([produces])
		elif getResAround:
			var thing = root.DetectAroundResourceBuildings(resTypes)
			if not thing.is_empty():
				root.GiveResources(thing)
