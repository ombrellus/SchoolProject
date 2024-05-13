extends Node

enum Resources {WOOD,ROCK,COIN,GOLD,DIAMOND}
enum Grounds {NATURE,MANMADE,WATER,SOLID,ALL}
enum BuildingType {RESOURCE,PRODUCER,DECORATION,MISC}

enum Powers {
	WOOD_CUTTER,
	STONE_CUTTER
}

var resourceIcons:Dictionary={
	Resources.WOOD: preload("res://ui/icons/logs.png"),
	Resources.ROCK: preload("res://ui/icons/rocks.png")
}

