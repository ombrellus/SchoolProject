extends Node

signal tryPlacing(pos:Vector2,tile:Vector2i,type:Global.Grounds,tileMap:TileMap)
signal buildingTouched
signal resourceProduced(got:Price,build:Building)
signal updateResources(cost:Price)
signal tryCreatingPortion(pos:Vector2)
signal buildingChosen(res:BuildingRes)
signal createPortion(cost:Array[Price])
