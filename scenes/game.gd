extends Node2D
class_name Game

var selectedBuilding:BuildingRes = preload("res://objects/building/res/house.tres")
var selectedWorldBuilding:Building
var pickedIcon:Texture2D
var selectedTile:Vector2i
var selectedTileMap:TileMap

var shopOpen:bool = false
var debug:bool = true

var priceTag:PackedScene = preload("res://ui/button/price_tag.tscn")

var heldResources:Dictionary = {
	Global.Resources.WOOD : 5,
	Global.Resources.ROCK : 0,
	Global.Resources.COIN : 15
}

@onready var handleStoppers:Array[Control] = [%BuildButtons, %DestroyButtons, $CanvasLayer/Control]

func _process(delta):
	if debug:
		if Input.is_action_just_pressed("debug1"):
			var p = Price.new()
			p.value = 4000
			p.type = Global.Resources.COIN
			GiveSingleResource(p)
		if Input.is_action_just_pressed("debug2"):
			selectedBuilding = preload("res://objects/building/res/factory.tres")
		if Input.is_action_just_pressed("debug3"):
			selectedBuilding = preload("res://objects/building/res/tree.tres")

func _ready():
	Global.mainGame = self
	Global.camera = $Camera2D
	Events.tryPlacing.connect(CheckBuildingPossibility)
	Events.buildingTouched.connect(OpenBuildingInfo)
	Events.resourceProduced.connect(GiveSingleResource)
	Events.buildingChosen.connect(ChangeBuilding)
	Events.createPortion.connect(PortionCreated)

func CheckBuildingPossibility(pos:Vector2,tile:Vector2i,type:Global.Grounds,tileMap:TileMap):
	if selectedBuilding == null:
		return
	if selectedBuilding.groundType != Global.Grounds.SOLID and selectedBuilding.groundType != Global.Grounds.ALL:
		if selectedBuilding.groundType != type:
			return
	elif selectedBuilding.groundType == Global.Grounds.SOLID:
		if type == Global.Grounds.WATER:
			return
	OpenBuildPanel()
	%Preview.visible = true
	%Preview.position = pos
	pickedIcon = selectedBuilding.icon.pick_random()
	%Preview.texture = pickedIcon
	selectedTile = tile
	selectedTileMap = tileMap
	
func Build():
	var build:Building = selectedBuilding.packed.instantiate()
	build.position = selectedTileMap.map_to_local(selectedTile)
	build.portion = selectedTileMap
	build.tile = selectedTile
	selectedTileMap.add_child(build)
	build.get_node("Sprite2D").texture = pickedIcon
	selectedTileMap.set_cell(1,selectedTile,selectedTileMap.get_cell_source_id(1,selectedTile),Vector2i(1,0))
	Spend(selectedBuilding.prices)
	CloseBuildPanel()

func ChangeBuilding(res:BuildingRes):
	selectedBuilding = res

func Destroy():
	GiveResources(selectedWorldBuilding.info.returnMaterial)
	selectedWorldBuilding.Destroy()
	CloseInfoPanel()

func moveResourceThing(off:Vector2):
	var tween = create_tween()
	tween.tween_property(%GridContainer,"position",off,0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func OpenBuildingInfo(build:Building,info:BuildingInfo):
	if shopOpen:
		CloseShop()
	CloseBuildPanel()
	%DestroyButtons.visible = true
	selectedWorldBuilding = build
	selectedTileMap = build.portion
	moveResourceThing(Vector2(0,-79))
func OpenBuildPanel():
	if shopOpen:
		CloseShop()
	%BuildButtons.visible = true
	CloseInfoPanel()
	moveResourceThing(Vector2(0,-79))
	for c in $CanvasLayer/BuildButtons/GridContainer.get_children():
		c.queue_free()
	for p:Price in selectedBuilding.prices:
		var cock:Control = priceTag.instantiate()
		cock.amount = p.value
		cock.icon = Global.resourceIcons[p.type]
		if p.value > heldResources[p.type]:
			cock.enough = false
		$CanvasLayer/BuildButtons/GridContainer.add_child(cock)
		cock.update()
	if not CheckPrices(selectedBuilding.prices):
		$CanvasLayer/BuildButtons/Build.disabled = true
	else:
		$CanvasLayer/BuildButtons/Build.disabled = false

func CloseBuildPanel():
	%BuildButtons.visible = false
	%Preview.visible = false
	moveResourceThing(Vector2(0,-22))

func ChangeShopPage(page:ScrollContainer,tab:Button):
	for i in [%ShopTabs.get_child(0),%ShopTabs.get_child(1),%ShopTabs.get_child(2)]:
		i.icon = i.icons[0]
		if i == tab:
			i.icon = i.icons[1]
	for i in %Shops.get_children():
		if i == page:
			i.visible = true
		else:
			i.visible = false

func CloseInfoPanel():
	%DestroyButtons.visible = false
	moveResourceThing(Vector2(0,-22))

func OpenShop():
	CloseBuildPanel()
	CloseInfoPanel()
	var tween = create_tween()
	tween.tween_property(%ShopMenu,"position",Vector2(630,0),0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func(): $CanvasLayer/ShopMenu/ShopTabs/Exit.visible = true)
	shopOpen = true

func CloseShop():
	var tween = create_tween()
	tween.tween_property(%ShopMenu,"position",Vector2(800,0),0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	$CanvasLayer/ShopMenu/ShopTabs/Exit.visible = false
	for i in %Shops.get_children():
		i.visible = false
	shopOpen = false

func CheckPrices(prices:Array[Price]) -> bool:
	for p:Price in prices:
		if heldResources[p.type] < p.value:
			return false
	return true

func Spend(prices:Array[Price]):
	for p:Price in prices:
		heldResources[p.type] -= p.value
		var negative = Price.new()
		negative.type = p.type
		negative.value = p.value*-1
		Events.updateResources.emit(negative)

func GiveResources(prices:Array[Price]):
	for p:Price in prices:
		heldResources[p.type] += p.value
		Events.updateResources.emit(p)

func PortionCreated(cost:Array[Price],portion:Node2D):
	Spend(cost)

func GiveSingleResource(price:Price,build:Building = null):
	heldResources[price.type] += price.value
	Events.updateResources.emit(price)
