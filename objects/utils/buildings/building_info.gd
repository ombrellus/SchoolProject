extends Resource
class_name BuildingInfo

@export var name:String
@export var size:Vector2i = Vector2(1,1)
@export var type:Global.BuildingType
@export var material:Global.Resources
@export var returnMaterial:Array[Price]
@export var alwaysBreakable:bool = true
@export var powerNeeded:Global.Powers
