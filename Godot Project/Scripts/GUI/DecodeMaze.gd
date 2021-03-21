extends Button



var ENCODED_CODE_1_MAX_LENGTH =6
var ENCODED_CODE_2_MAX_LENGTH =6
var ENCODED_CODE_3_MAX_LENGTH =4

var DECODED_CODE_1_MAX_LENGTH =10
var DECODED_CODE_2_MAX_LENGTH =10
var DECODED_CODE_3_MAX_LENGTH =6

var MAX_STATES_MAZECREATOR = 7
var MAX_TOPIC_INT=2
var USER_ARRAY_MAX_LENGTH = 3


var topic_selected = null
var bool_code_decoded

var default_text = "Please input your friend's code below.\n- you must include the (-) \n- the code is case sensitive"
var incorrect_code_text= "Incorrect Code. Please try again."
var empty_input_text = "Nothing was entered. Please enter the code"
var success_text = "Successfully decoded!\nClick play to beign your adventure!."

var path_to_char_select ="res://Scenes/Menu Scenes/Select_Character/CharacterSelection.tscn";

onready var popup_label = get_node("../../PopupLabel")
onready var user_line_edit = get_node("../../UserCode")
onready var confirm_button = get_node("../ConfirmButton")
onready var alert_dialog = get_node("../../..")


# Called when the node enters the scene tree for the first time.
func _ready():
	popup_label.text = default_text.to_upper()
	confirm_button.text = "decode".to_upper()
	bool_code_decoded = false



func _on_ConfirmButton_pressed():
	if(bool_code_decoded==false):
		decode_user_code()
	else:
		get_tree().change_scene(path_to_char_select)
		GlobalVariables.world_num= 2
		print("Selected world ",GlobalVariables.world_num)
		print("Selected topic ",GlobalVariables.topic_selected)
		print("Maze ",GlobalVariables.maze_creator_map)

func _on_SWAlertCancelButton_pressed():
	alert_dialog.visible=false
	default_message_setting()

func _on_WindowDialog_draw():
	default_message_setting()

func default_message_setting():
	popup_label.text = default_text.to_upper()
	confirm_button.text = "Confirm".to_upper()
	confirm_button.text = "decode".to_upper()
	user_line_edit.visible = true
	user_line_edit.clear()
	bool_code_decoded = false

func error_message_setting():
	popup_label.text = incorrect_code_text.to_upper()

func success_message_setting():
	popup_label.text = success_text.to_upper()
	confirm_button.text = "Play".to_upper()
	user_line_edit.visible = false

func decode_user_code():
	var user_entered_text
	var user_code_array
	var decoded_array
	var decoded_maze
	var user_code_1
	var user_code_2
	var user_code_3
	var decoded_code_1
	var decoded_code_2
	var decoded_code_3
	
	user_entered_text = user_line_edit.get_text()
	
	if(check_user_entered_string(user_entered_text)== true): 
		#print("User keyed code with - in the line edit")
		user_code_array = user_entered_text.split("-")
		if(check_user_array(user_code_array)==true):
				#print("The array converted length is 3")
				user_code_1 = user_code_array[0]
				user_code_2 = user_code_array[1]
				user_code_3 = user_code_array[2]
				#print(user_code_1,user_code_2,user_code_3)
				if(check_all_codes_length(user_code_1,user_code_2,user_code_3)==true):
					#print("Length of each part of code is ok")
					decoded_array = decode_all_codes(user_code_1,user_code_2,user_code_3)
					decoded_code_1 = decoded_array[0]
					decoded_code_2 = decoded_array[1]
					decoded_code_3 = decoded_array[2]
					#print(decoded_code_1," ",decoded_code_2," ",decoded_code_3)
					if(check_all_decoded_code(decoded_code_1,decoded_code_2,decoded_code_3)==true):
						decoded_maze = create_maze(decoded_code_1, decoded_code_2, decoded_code_3)
						#print(decoded_maze)
						#print(topic_selected)
						GlobalVariables.maze_creator_map = decoded_maze
						GlobalVariables.topic_selected = topic_selected
						success_message_setting()
						bool_code_decoded = true 
					
					


# function to check if user has keyed in code 
func check_user_entered_string(user_entered_text):
	if(user_entered_text == null or len(user_entered_text)==0):
		popup_label.text = empty_input_text.to_upper()
		return false 
	elif(not "-" in user_entered_text):
		error_message_setting()
		return false
		
	else: return true

# returns bool, true if all length is correct
func check_all_codes_length(code_1, code_2, code_3):
	var code_1_result = check_code_length(code_1,ENCODED_CODE_1_MAX_LENGTH)
	var code_2_result = check_code_length(code_2,ENCODED_CODE_2_MAX_LENGTH) 
	var code_3_result = check_code_length(code_3,ENCODED_CODE_3_MAX_LENGTH)
	
	if((code_1_result and code_2_result and code_3_result)==true):return true
	else: 
		error_message_setting()
		return false

# function to check if given code is wihtin its max length, returns true if code is within the length
func check_code_length(code,MAX_LENGTH):
	if(len(code)>0 and len(code)<MAX_LENGTH+1): 
		return true
	else:
		return false

# function to check if the array is within 3
func check_user_array(array):
	if(array.size() != USER_ARRAY_MAX_LENGTH): return false 
	else: return true





# function to decode the code for all the 3 parts
func decode_all_codes(code_1, code_2, code_3):
	# decode the from the base 64 to the numeric string
	var decoded_base64_code_1 = decode_from_base64(code_1)
	var decoded_base64_code_2 = decode_from_base64(code_2)
	var decoded_base64_code_3 = decode_from_base64(code_3)
	#print(decoded_base64_code_1, " ",decoded_base64_code_2, " ",decoded_base64_code_3)
	
	var decoded_with_zeros_code_1 = append_zeros_to_decoded_base64(decoded_base64_code_1,DECODED_CODE_1_MAX_LENGTH)
	var decoded_with_zeros_code_2 = append_zeros_to_decoded_base64(decoded_base64_code_2,DECODED_CODE_2_MAX_LENGTH)
	var decoded_with_zeros_code_3 = append_zeros_to_decoded_base64(decoded_base64_code_3,DECODED_CODE_3_MAX_LENGTH)
	#print(decoded_with_zeros_code_1, " ",decoded_with_zeros_code_2, " ",decoded_with_zeros_code_3)
	
	return [decoded_with_zeros_code_1,decoded_with_zeros_code_2,decoded_with_zeros_code_3]

# function that decodes from base 64 and returns result in string 
# example if 006123 was encoded earlier, it will decode as 6123 and
# return this as string (int to string)
func decode_from_base64(code):
	if(code == "#"):
		return "0"
	else:
		return str(GlobalVariables.decode(code ,GlobalVariables.BASE64_DIGITS))

# function adds zeros infront according to the max length of the 
# example if max length was 5 and the code is 123, after appending
# it will become 00123
func append_zeros_to_decoded_base64(decoded_base64,MAX_LENGTH):
	#print("len = ",len(code), " MAX L = ",MAX_LENGTH)
	if(len(decoded_base64)<MAX_LENGTH):
		decoded_base64 = decoded_base64.pad_zeros(MAX_LENGTH)
	return decoded_base64



# function to check all decoded codes if each digit is within its 0-6 for Maze part and 0-2 for Topic part
func check_all_decoded_code(decoded_code_1, decoded_code_2, decoded_code_3):
	var decoded_code_1_result = check_decoded_code(decoded_code_1)
	var decoded_code_2_result = check_decoded_code(decoded_code_2)
	var decoded_code_3_result = check_decoded_code(decoded_code_3)
	
	if((decoded_code_1_result and decoded_code_2_result and decoded_code_3_result)==true):return true
	else: 
		error_message_setting()
		return false

# function to check if each digit is within its 0-6 for Maze part and 0-2 for Topic part for given decoded code
func check_decoded_code(decoded_code):
	if(len(decoded_code)==DECODED_CODE_3_MAX_LENGTH):
		for x in len(decoded_code):
			if(int(decoded_code[x])>MAX_STATES_MAZECREATOR or int(decoded_code[x])<0): return false
			if(x==(len(decoded_code)-1)):
				if(int(decoded_code[x])>MAX_TOPIC_INT or int(decoded_code[x])<0): return false
		return true
	else:
		for x in len(decoded_code):
			if(int(decoded_code[x])>MAX_STATES_MAZECREATOR or int(decoded_code[x])<0): return false
		return true


# creates the maze array and the topic integer
func create_maze(decoded_code_1, decoded_code_2, decoded_code_3):
	var oned_array_of_maze = []
	var maze_decoded
	
	oned_array_of_maze = add_decoded_code_to_1d_array(decoded_code_1,oned_array_of_maze)
	#print("Topic Selected :",topic_selected)
	oned_array_of_maze = add_decoded_code_to_1d_array(decoded_code_2,oned_array_of_maze)
	#print("Topic Selected :",topic_selected)
	oned_array_of_maze = add_decoded_code_to_1d_array(decoded_code_3,oned_array_of_maze)
	#print("Topic Selected :",topic_selected)
	#print(oned_array_of_maze)
	
	maze_decoded = convert_1d_array_to_2d_array(oned_array_of_maze)
	#print(maze_decoded)
	return maze_decoded
	

# adds the decoded code to given 1d array
func add_decoded_code_to_1d_array(decoded_code, array_to_add):
	if(len(decoded_code)==DECODED_CODE_3_MAX_LENGTH):
		for x in len(decoded_code):
			if(x==(len(decoded_code)-1)): topic_selected = int(decoded_code[x]) #set topic 
			else: array_to_add.append(decoded_code[x])
	else:
		for x in len(decoded_code): array_to_add.append(decoded_code[x])
		
	return array_to_add

# converts the 1d array and returns the maze map
func convert_1d_array_to_2d_array(oneD_array):
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













