extends Resource
class_name BuildingRes

@export var name:String
@export var size:Vector2i = Vector2(1,1)
@export var icon:Array[Texture2D]
@export_multiline var desc:String
@export var prices:Array[Price]
@export var groundType:Global.Grounds
@export var packed:PackedScene
