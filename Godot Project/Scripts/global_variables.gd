extends Node

var world_num = 0
var maze_creator_map = []
var BASE64_DIGITS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'


enum ItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

enum RoomEnum {VOID_ROOM, CHALLENGE_ROOM_EASY, CHALLENGE_ROOM_MED, CHALLENGE_ROOM_HARD,
BOSS_ROOM, SHOP_ROOM, STARTING_ROOM, EMPTY_ROOM}

func decode(data, source):
	var value = 0
	for d in data:
		if d in source:
			value = value * len(source)
			value = value + source.find(d)
	return value


func encode(data, target):
	var result = ''
	while int(data) > 0:
		var r = int(data % len(target))
		result = target[r] + result
		data = data / len(target)
	return result


# data ... number that should be transcoded
# target ... target system the number should be encoded to
# source ... system the number is currently encoded in
func transcode(data, target, source):
	return encode(decode(data, source), target)
	
	
	
func grid_to_string(grid_to_convert):
	var grid_string = ""
	for x in range(len(grid_to_convert)):
		#print(arr[x])
		for  i in range(len(grid_to_convert[x])):
			grid_string+=str(grid_to_convert[x][i])
			#print(grid_string)
	return grid_string
	
func _ready():
	pass # Replace with function body.


