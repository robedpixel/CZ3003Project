extends Node

var world_num = 0
var maze_creator_map = []

enum ItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

enum RoomEnum {VOID_ROOM, CHALLENGE_ROOM_EASY, CHALLENGE_ROOM_MED, CHALLENGE_ROOM_HARD,
BOSS_ROOM, SHOP_ROOM, STARTING_ROOM, EMPTY_ROOM, MAX_ROOM_ENUM}

var monsterDifficultyRewardModifier = {
	"EASY" : 1.5,
	"MED" : 2.0,
	"HARD" : 3.0
}

func _ready():
	pass # Replace with function body.


