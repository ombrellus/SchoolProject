extends Node

enum Resources {WOOD,ROCK,COIN,GOLD,DIAMOND}
enum Grounds {NATURE,MANMADE,WATER,SOLID,ALL}
enum BuildingType {RESOURCE,PRODUCER,DECORATION,MISC}

enum Powers {
	WOOD_CUTTER,
	STONE_CUTTER,
	POTTERY
}

var boughtPowers:Dictionary={
	Powers.WOOD_CUTTER:false,
	Powers.STONE_CUTTER:false,
	Powers.POTTERY:false
}

var mainGame:Game
var camera:Camera2D

var resourceIcons:Dictionary={
	Resources.WOOD: preload("res://ui/icons/logs.png"),
	Resources.ROCK: preload("res://ui/icons/rocks.png"),
	Resources.COIN: preload("res://ui/icons/coins.png"),
	Resources.GOLD: preload("res://ui/icons/gold.png")
}
