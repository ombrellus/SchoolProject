extends Button

@export var icons:Array[Texture2D]
@export var selection:BuildingRes

func _ready():
	icon = icons[0]
	Events.buildingChosen.connect(change)


func change(res:BuildingRes):
	if res!= selection:
		icon = icons[0]
	else: icon = icons[1]


func _on_button_up():
	Events.buildingChosen.emit(selection)
