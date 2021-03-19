extends Node

var world_num = 0
var maze_creator_map
var charSelected = 0


enum ItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

enum RoomEnum {VOID_ROOM, CHALLENGE_ROOM_EASY, CHALLENGE_ROOM_MED, CHALLENGE_ROOM_HARD,
BOSS_ROOM, SHOP_ROOM, STARTING_ROOM, EMPTY_ROOM, MAX_ROOM_ENUM}

var monsterDifficultyRewardModifier = {
	"EASY" : 1.5,
	"MED" : 2.0,
	"HARD" : 3.0,
	"BOSS": 5.0
}

var charSelected = 1

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

##################################################################################################################

var oned_array_of_maze = []
var topic_selected = null
var ENCODED_CODE_1_MAX_LENGTH =6
var ENCODED_CODE_2_MAX_LENGTH =6
var ENCODED_CODE_3_MAX_LENGTH =4

var DECODED_CODE_1_MAX_LENGTH =10
var DECODED_CODE_2_MAX_LENGTH =10
var DECODED_CODE_3_MAX_LENGTH =6

var MAX_STATES_MAZECREATOR = 7
var MAX_TOPIC_INT=2

var BASE64_DIGITS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$&'

func generated_code_to_string(code_1,code_2,code_3):
	# Check if the 3 part of the of is within the length of 6 , 6 and 4 respectively
	var bool_code_check_result = (check_code(code_1,ENCODED_CODE_1_MAX_LENGTH) and check_code(code_2,ENCODED_CODE_2_MAX_LENGTH) 
	and check_code(code_3,ENCODED_CODE_3_MAX_LENGTH))
	
	print("Code Check: ",bool_code_check_result)
	if(bool_code_check_result==true):
		# decode the from the base 64 to the numeric
		var decoded_code_1_string = full_decode_ret_string(code_1)
		var decoded_code_2_string = full_decode_ret_string(code_2)
		var decoded_code_3_string = full_decode_ret_string(code_3)
		#print(decoded_code_1_string, "-",decoded_code_2_string,"-",decoded_code_3_string)
		
		# append 0 if needed for the 3 part of the decoded codes. 10 , 10 , 6
		var full_string_part_1 = append_zero_to_code(decoded_code_1_string,DECODED_CODE_1_MAX_LENGTH)
		var full_string_part_2 = append_zero_to_code(decoded_code_2_string,DECODED_CODE_2_MAX_LENGTH)
		var full_string_part_3 = append_zero_to_code(decoded_code_3_string,DECODED_CODE_3_MAX_LENGTH)
		
		# check if the full string is relevant to the maze 
		var bool_check_full_string = (check_full_string(full_string_part_1) and check_full_string(full_string_part_2)
		and check_full_string(full_string_part_3))
		
		if(bool_check_full_string==true):
			add_string_to_1d_array(full_string_part_1)
			add_string_to_1d_array(full_string_part_2)
			add_string_to_1d_array(full_string_part_3)
			
			#print(oned_array_of_maze)
			#print(topic_selected)
			
			maze_creator_map= oned_to_2d_array(oned_array_of_maze)
			#print(oned_array_of_maze)
			print("Decoded maze: ",maze_creator_map)
			print("Topic Selected ",topic_selected)
			

func full_decode_ret_string(code):
	if(code == "#"):
		return "0"
	else:
		return str(GlobalVariables.decode(code ,GlobalVariables.BASE64_DIGITS))

func append_zero_to_code(code,MAX_LENGTH):
	#print("len = ",len(code), " MAX L = ",MAX_LENGTH)
	if(len(code)<MAX_LENGTH):
		code = code.pad_zeros(MAX_LENGTH)
	return code

func check_code(code,MAX_LENGTH):
	if(len(code)>0 and len(code)<MAX_LENGTH+1): 
		return true
	else:
		return false

func check_full_string(full_string):
	if(len(full_string)==DECODED_CODE_3_MAX_LENGTH):
		for x in len(full_string):
			if(int(full_string[x])>MAX_STATES_MAZECREATOR or int(full_string[x])<0): return false
			if(x==(len(full_string)-1)):
				if(int(full_string[x])>MAX_TOPIC_INT or int(full_string[x])<0): return false
		return true
	else:
		for x in len(full_string):
			if(int(full_string[x])>MAX_STATES_MAZECREATOR or int(full_string[x])<0): return false
		return true

func add_string_to_1d_array(full_string):
	if(len(full_string)==DECODED_CODE_3_MAX_LENGTH):
		for x in len(full_string):
			if(x==(len(full_string)-1)): topic_selected = full_string[x]
			else: oned_array_of_maze.append(full_string[x])
	else:
		for x in len(full_string): oned_array_of_maze.append(full_string[x])

func oned_to_2d_array(oneD_array):
	var maze_decoded = []
	var temp = []
	for x in len(oneD_array):
		if(x!=0):
			if(x%5==0):
				maze_decoded.append(temp)
				temp = []
		temp.append(oneD_array[x])
		if(x == len(oneD_array)-1): maze_decoded.append(temp)
	#print(maze_decoded)
	return maze_decoded
##############################################################################################################################
func _ready():
	pass # Replace with function body.


