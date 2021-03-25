extends Node

var world_num = null
var maze_creator_map = null
var bool_custom_maze = false
var topic_selected = null
var charSelected = 0
var score = 0


enum ItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

enum RoomEnum {VOID_ROOM, CHALLENGE_ROOM_EASY, CHALLENGE_ROOM_MED, CHALLENGE_ROOM_HARD,
BOSS_ROOM, SHOP_ROOM, STARTING_ROOM, EMPTY_ROOM, MAX_ROOM_ENUM}

enum TopicEnum {TOPIC_1, TOPIC_2, CUSTOM_TOPIC, MAX_TOPIC_ENUM}

var monsterDifficultyRewardModifier = {
	"EASY" : 1.5,
	"MED" : 2.0,
	"HARD" : 3.0,
	"BOSS": 5.0
}


var BASE64_DIGITS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$&'

# Decodes an encoded number into a decimal number.
#
# data ... the encoded number (string)
# source ... the system the number is encoded in (string)
func decode(data, source):
	var value = 0
	for d in data:
		if d in source:
			value = value * len(source)
			value = value + source.find(d)
	return value

# Encodes a decimal number into system given by target
#
# data ...  number that should be encoded
# target ... system the number should be encoded to
func encode(data, target):
	var result = ''
	while int(data) > 0:
		var r = int(data % len(target))
		result = target[r] + result
		data = data / len(target)
	return result


# Transcodes a number from one numeric system to another.
# For examples to see how a 'system' should look like, take a
# look at the constants BASE64_DIGITS, BASE16_DIGITS (hexadecimal),
# string.digits (decimal), string.octdigits (octal)
# and BASE2_DIGITS (binary)
#
# Unsigned numbers only since the '-' character could also be
# used as a digit.
#
# All the parameters should be Strings!
# data ... number that should be transcoded
# target ... target system the number should be encoded to
# source ... system the number is currently encoded in
func transcode(data, target, source):
	return encode(decode(data, source), target)
####



func post_to_telegram(world,score , maze_code:String,student_name):
	var http = HTTPRequest.new()
	add_child(http)
	
	var url ="https://api.telegram.org/bot1765926387:AAEgU23J1uNMdpMTX-uvnbDtKJGIe1i5Hpk/sendMessage?chat_id=@ssad_class&text="
	var game_message 
	if(maze_code==null):
		if(world == 0):
			game_message = "Hey%21+Check+out+my+score+for+Requirement+Analysis.+My+score+is+"+ score+" . %0A%0A - " + student_name
		elif(world == 1):
			game_message = "Hey%21+Check+out+my+score+for+Requirement+Engineering.+My+score+is+"+ score +" . %0A%0A- " + student_name
		else: print("error")
	else:
		game_message = "Hey%21+Try+out+my+maze.+Here+is+the+code "+ maze_code.percent_encode() + " . %0A%0A- " + student_name
	http.request(url+game_message, [], true, HTTPClient.METHOD_POST, "")

func post_to_facebook():
	OS.shell_open("https://www.facebook.com/groups/4064171876949849")

func post_to_twitter(world,score , maze_code:String,student_name):
	var game_message 
	if(maze_code==null):
		if(world == 0):
			game_message = "Hey%21+Check+out+my+score+for+Requirement+Analysis.+My+score+is+"+ score+" . %0A%0A - " + student_name
		elif(world == 1):
			game_message = "Hey%21+Check+out+my+score+for+Requirement+Engineering.+My+score+is+"+ score +" . %0A%0A- " + student_name
		else: print("error")
	else:
		game_message = "Hey%21+Try+out+my+maze.+Here+is+the+code "+ maze_code.percent_encode() + " . %0A%0A- " + student_name
	
	
	OS.shell_open("https://twitter.com/intent/tweet?text="+game_message)

func _ready():
	pass # Replace with function body.


