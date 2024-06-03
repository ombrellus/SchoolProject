extends Button

@export var icons:Array[Texture2D]
@export var selection:ScrollContainer
@export var startOn:bool = false

func _ready():
	if not startOn:
		icon = icons[0]
	else: icon = icons[1]


func _on_button_up():
	if not Global.mainGame.shopOpen:
		Global.mainGame.OpenShop()
	Global.mainGame.ChangeShopPage(selection,self)
