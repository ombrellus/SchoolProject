extends Node2D

var selectedBuilding:BuildingRes = preload("res://objects/building/res/house.tres")
var pickedIcon:Texture2D
var selectedTile:Vector2i
var selectedTileMap:TileMap

var heldResources:Dictionary = {
	Global.Resources.WOOD : 20
}

func _ready():
	Events.tryPlacing.connect(CheckBuildingPossibility)

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
	$BuildZone.add_child(build)
	build.get_node("Sprite2D").texture = pickedIcon
	selectedTileMap.set_cell(1,selectedTile,selectedTileMap.get_cell_source_id(1,selectedTile),Vector2i(1,0))
	Spend(selectedBuilding.prices)
	CloseBuildPanel()
	

func OpenBuildPanel():
	%BuildButtons.visible = true
	if not CheckPrices(selectedBuilding.prices):
		$CanvasLayer/BuildButtons/Build.disabled = true
	else:
		$CanvasLayer/BuildButtons/Build.disabled = false

func CloseBuildPanel():
	%BuildButtons.visible = false
	%Preview.visible = false

func CheckPrices(prices:Array[Price]) -> bool:
	for p:Price in prices:
		if heldResources[p.type] < p.value:
			return false
	return true

func Spend(prices:Array[Price]):
	for p:Price in prices:
		heldResources[p.type] -= p.value
