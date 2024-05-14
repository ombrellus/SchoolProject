extends Building
class_name ProducerBuilding

@export var maxSpeed:float = 3
var speed:float = 3

func _ready():
	speed = maxSpeed


func _process(delta):
	if speed > 0:
		speed -= delta
	else:
		speed = maxSpeed
		var  ps:Array[Price] = DetectAroundResourceBuildings()
		if not ps.is_empty():
			GiveResources(ps)
