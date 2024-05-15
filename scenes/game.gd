extends Node2D
class_name Game

var selectedBuilding:BuildingRes = preload("res://objects/building/res/house.tres")
var selectedWorldBuilding:Building
var pickedIcon:Texture2D
var selectedTile:Vector2i
var selectedTileMap:TileMap

var debug:bool = true

var priceTag:PackedScene = preload("res://ui/button/price_tag.tscn")

var heldResources:Dictionary = {
	Global.Resources.WOOD : 20,
	Global.Resources.ROCK : 0,
	Global.Resources.COIN : 70000
}

func _process(delta):
	if debug:
		if Input.is_action_just_pressed("debug1"):
			selectedBuilding = preload("res://objects/building/res/house.tres")
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
	

func Destroy():
	GiveResources(selectedWorldBuilding.info.returnMaterial)
	selectedWorldBuilding.Destroy()
	CloseInfoPanel()

func moveResourceThing(off:Vector2):
	var tween = create_tween()
	tween.tween_property(%GridContainer,"position",off,0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func OpenBuildingInfo(build:Building,info:BuildingInfo):
	CloseBuildPanel()
	%DestroyButtons.visible = true
	selectedWorldBuilding = build
	selectedTileMap = build.portion
	moveResourceThing(Vector2(0,-60))
func OpenBuildPanel():
	%BuildButtons.visible = true
	CloseInfoPanel()
	moveResourceThing(Vector2(0,-60))
	for c in $CanvasLayer/BuildButtons/GridContainer.get_children():
		c.queue_free()
	for p:Price in selectedBuilding.prices:
		var cock:Control = priceTag.instantiate()
		cock.amount = p.value
		cock.icon = Global.resourceIcons[p.type]
		$CanvasLayer/BuildButtons/GridContainer.add_child(cock)
		cock.update()
	if not CheckPrices(selectedBuilding.prices):
		$CanvasLayer/BuildButtons/Build.disabled = true
	else:
		$CanvasLayer/BuildButtons/Build.disabled = false

func CloseBuildPanel():
	%BuildButtons.visible = false
	%Preview.visible = false
	moveResourceThing(Vector2(0,0))
	

func CloseInfoPanel():
	%DestroyButtons.visible = false
	moveResourceThing(Vector2(0,0))
	

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
		

func GiveSingleResource(price:Price,build:Building = null):
	heldResources[price.type] += price.value
	Events.updateResources.emit(price)
