extends GridContainer

# Dictionary that contains the info of each button
# "button_key" : [0,1,2] where,
# 0 = buton path of node, 1 = x axis of button, 2 = y axis of button
onready var buttons_dict= {
	"btn_x0y4":["Button_X0Y4",0,4],"btn_x1y4":["Button_X1Y4",1,4],
	"btn_x2y4":["Button_X2Y4",2,4],"btn_x3y4":["Button_X3Y4",3,4],
	"btn_x4y4":["Button_X4Y4",4,4],
	
	"btn_x0y3":["Button_X0Y3",0,3],"btn_x1y3":["Button_X1Y3",1,3],
	"btn_x2y3":["Button_X2Y3",2,3],"btn_x3y3":["Button_X3Y3",3,3],
	"btn_x4y3":["Button_X4Y3",4,3],
	
	"btn_x0y2":["Button_X0Y2",0,2],"btn_x1y2":["Button_X1Y2",1,2],
	"btn_x2y2":["Button_X2Y2",2,2],"btn_x3y2":["Button_X3Y2",3,2],
	"btn_x4y2":["Button_X4Y2",4,2],
	
	"btn_x0y1":["Button_X0Y1",0,1],"btn_x1y1":["Button_X1Y1",1,1],
	"btn_x2y1":["Button_X2Y1",2,1],"btn_x3y1":["Button_X3Y1",3,1],
	"btn_x4y1":["Button_X4Y1",4,1],
	
	"btn_x0y0":["Button_X0Y0_Start",0,0],"btn_x1y0":["Button_X1Y0",1,0],
	"btn_x2y0":["Button_X2Y0",2,0],"btn_x3y0":["Button_X3Y0",3,0],
	"btn_x4y0":["Button_X4Y0",4,0]
	}
onready var confirm_btn = get_node("../ConfirmButton")
onready var alert_dialog = get_node("../WindowDialog")
onready var alert_label = get_node("../WindowDialog/VBoxContainer/AlertLabel")
onready var alert_line_edit = get_node("../WindowDialog/VBoxContainer/AlertLineEdit")
onready var alert_button = get_node("../WindowDialog/VBoxContainer/AlertButton")
onready var alert_social_media= get_node("../WindowDialog/VBoxContainer/Social Media")
onready var topic_label = get_node("../TopicLabel")
onready var topic_button = get_node("../TopicChooserButton")


var path_to_select_world = "res://Scenes/Menu Scenes/Select_World/SW.tscn"

var button_grid = [] # the maze to be created
var boss_exists  # Boolean to see if the boss already exits
var boss_x_axis # Boss x axis
var boss_y_axis # Boss y axis
var store_exists  # Boolean to see if the store already exits
var code_1 = null
var code_2 = null
var code_3 = null
var height = 5  # height of the map
var width = 5   # width of the map
var topic_int = 0
var bool_maze_encoded
var full_maze_code
var handler
var student_name



# Called when the node enters the scene tree for the first time.
func _ready():
	generate_layout(height,width)
	initial_button_text()
	boss_exists = false
	store_exists = false
	topic_button.visible=false
	topic_label.visible = false
	alert_social_media.visible = false
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	student_name = yield(handler.get_student_name(), "completed")
	
	#print(button_grid)


# Function that initailies all (x,y) axis to 0 except (0,0) to 6 as it is the start
func generate_layout(var height,var width):
	for x in range(width):
		button_grid.append([])
		for y in range(height):
			button_grid[x].append([])
			if(x==0 and y==0):
				button_grid[x][y]=6
			else:
				button_grid[x][y]=0

# Function that to initialize the text on the UI of the grid container
func initial_button_text():
	print(len(buttons_dict))
	for key in buttons_dict.keys():
		var button_node = get_node(buttons_dict[key][0])
		var x = buttons_dict[key][1]
		var y = buttons_dict[key][2]
		button_node.text=get_state_name(button_grid[x][y])
	

#funtion to get the name of the state, uses swtich case
func get_state_name(state):
	match(state): 
		0 : return ""
		1 : return "easy"
		2 : return "meduim"
		3 : return "hard"
		4 : return "boss"
		5 : return "store"
		6 : return "start"
		7 : return "empty"
		_ : return "error"

# function to set the state, the parameter state refers to button state
func set_state_int(state):
	if state<7:
		check_for_boss_existence()
		check_for_store_existence()
		#print("Boss: ", boss_exists, " Store: ", store_exists)
		
		if(state==3 and boss_exists==true):
			print("boss exist")
			state=set_state_int(4)
			return state
		elif(state==4 && store_exists==true):
			print("store exist")
			state= 7
			return state
		elif(state == 5):
			state = 7
			return state
		else: state=state+1
		#print(state)
		return state
	else: 
		check_for_boss_existence()
		check_for_store_existence()
		#print("Boss: ", boss_exists, " Store: ", store_exists)
		state=0
		return state

# function to check if the boss already exist in the maze, if exists the boss_exists = true
func check_for_boss_existence():
	for x in range(width):
		for y in range(height):
			if(button_grid[x][y]==4):
				boss_exists=true
				boss_x_axis = x
				boss_y_axis = y
				confirm_btn.disabled=false
				update_topic_button_text()
				topic_button.visible=true
				topic_label.visible= true
				return
	boss_exists=false
	confirm_btn.disabled=true
	topic_button.visible=false
	topic_label.visible= false
	return 

# function to check if the store already exist in the maze, if exists the store_exists = true
func check_for_store_existence():
	for x in range(width):
		for y in range(height):
			if(button_grid[x][y]==5):
				store_exists=true
				return
	store_exists=false
	return 

# function to set the map for searching
# 0 = accessible area, -1 =  non acessible area
func convert_map_dual_state(grid):
	for x in range(width):
		for y in range(height):
			if(grid[x][y]==0):
				grid[x][y]=-1
			else:
				grid[x][y]=0
	return grid

# search algorithm to find path to boss location
func search_algorithm(grid_to_search, boss_x, boss_y):
	#print(boss_x,",",boss_y)
	#print("GRID: ",grid_to_search)
	#					up  	down	right	left
	var direction = [ [0, 1], [0, -1], [1, 0], [-1, 0]]
	var queue = []
	var current_position
	var next_x
	var next_y
	var visited = 1;
	var blocked = -1;
	
	queue.append(Vector2(0, 0))
	while(len(queue) > 0) :
		current_position = queue[0]
		#print("Current Pos: ",current_position)
		queue.remove(0)
		grid_to_search[current_position[0]][current_position[1]] = visited #set visited =1
		if(current_position == (Vector2(boss_x, boss_y))) :
			return true
		for i in range(4) :
			next_x = current_position[0] + direction[i][0]
			next_y = current_position[1] + direction[i][1]
			if(next_x >= 0 and next_y >= 0 
				and next_x < width and next_y < height
				and grid_to_search[next_x][next_y] != visited
				and grid_to_search[next_x][next_y] != blocked) :
				queue.append(Vector2(next_x, next_y))
	return false

# generic function that determines what happens on button click
func button_press(var button_name):
	var x = buttons_dict[button_name][1]
	var y = buttons_dict[button_name][2]
	var button_node = get_node(buttons_dict[button_name][0])
	
	button_grid[x][y] = set_state_int(button_grid[x][y])
	button_node.text= get_state_name(button_grid[x][y])
	check_for_boss_existence()
	#print(button_grid)
	
func split_grid_to_encode(grid_to_convert):
	var grid_string_1 = ""
	var grid_string_2 = ""
	var grid_string_3 = ""
	
	for x in range(len(grid_to_convert)):
		#print(grid_to_convert[x])
		for  i in range(len(grid_to_convert[x])):
			if(x<2):
				grid_string_1+=str(grid_to_convert[x][i])
				#print("String:" ,grid_string_1)
				#print("Int   :",int(grid_string_1))
				#print("")
			elif(x>1 and x<4):
				grid_string_2+=str(grid_to_convert[x][i])
				#print("String:" ,grid_string_2)
				#print("Int   :",int(grid_string_2))
				#print("")
			else:
				grid_string_3+=str(grid_to_convert[x][i])
	#print([grid_string_1,grid_string_2,grid_string_3])
	return [grid_string_1,grid_string_2,grid_string_3]

func generate_code(button_grid,topic_number):
	var grid_string_1
	var grid_string_2
	var grid_string_3
	
	grid_string_1 = split_grid_to_encode(button_grid)[0]
	grid_string_2 = split_grid_to_encode(button_grid)[1]
	grid_string_3 = split_grid_to_encode(button_grid)[2] + str(topic_number)
	
#	print("ALL GRID STRINGS:")
#	print(grid_string_1)
#	print(grid_string_2)
#	print(grid_string_3)
#	print("")
#	print("ALL GRID INTS:")
#	print(int(grid_string_1))
#	print(int(grid_string_2))
#	print(int(grid_string_3))
#	print("")
	code_1 =  encode_to_Base64(int(grid_string_1))
	code_2 =  encode_to_Base64(int(grid_string_2))
	code_3 =  encode_to_Base64(int(grid_string_3))
	#print(code_1,"-",code_2,"-",code_3)
	#print(len(code_1),"-",len(code_2),"-",len(code_3))
	
func encode_to_Base64(value:int):
	if(value==0):
		return "#"
	else:
		return GlobalVariables.encode(value, GlobalVariables.BASE64_DIGITS)
	
# function for confirmation of press
func _on_ConfirmButton_pressed():
	var convert_button_grid = button_grid.duplicate(true)
	var converted_grid = convert_map_dual_state(convert_button_grid)
	#print(converted_grid)
	var path_exists = search_algorithm(converted_grid,boss_x_axis,boss_y_axis)
	
	if(path_exists ==  true):
		print("Created Maze: ", button_grid)
		generate_code(button_grid,topic_int)
		alert_dialog.visible=true
		alert_line_edit.visible = true
		alert_social_media.visible = true
		alert_dialog.window_title = ""
		alert_label.text = "SUCCESS!\nYOUR CODE IS" 
		alert_line_edit.text= code_1 + "-" + code_2 + "-" + code_3
		alert_button.text = "Go to maze"
		bool_maze_encoded = true
		full_maze_code = code_1 + "-" + code_2 + "-" + code_3
		#print("Path exists: ", path_exists)
	else:
		alert_dialog.visible=true
		alert_line_edit.visible = false
		alert_social_media.visible = false
		alert_dialog.window_title = "ERROR"
		alert_label.text = "NO PATH TO BOSS TILE!"
		alert_button.text = "Close"
		bool_maze_encoded = false
		full_maze_code = null
		#print("Path does not exist")


func update_topic_button_text():
	match(topic_int): 
		0 : topic_button.text= "1.Requirement Analysis"
		1 : topic_button.text= "2.Requirement Elicitation"
		2 : topic_button.text= "3.Both Topics"
		_ : return "error"

func _on_TopicChooserButton_pressed():
	#print(topic_int)
	if topic_int<2:
		topic_int=topic_int+1
		update_topic_button_text()
	else: 
		topic_int=0
		update_topic_button_text()
	#print(topic_int)

func _on_AlertButton_pressed():
	if(bool_maze_encoded==false):
		alert_dialog.visible=false
	else:
		get_tree().change_scene(path_to_select_world)


func _on_Telegram_pressed():
	GlobalVariables.post_to_telegram(null,null,full_maze_code,student_name)


func _on_Twitter_pressed():
	GlobalVariables.post_to_twitter(null,null,full_maze_code,student_name)


func _on_Facebook_pressed():
	GlobalVariables.post_to_facebook()
####################		The functions below are totally for each button		############################

#########################  				 Y axis = 4				#########################
func _on_Button_X0Y4_pressed():
	button_press("btn_x0y4")

func _on_Button_X1Y4_pressed():
	button_press("btn_x1y4")

func _on_Button_X2Y4_pressed():
	button_press("btn_x2y4")
	
func _on_Button_X3Y4_pressed():
	button_press("btn_x3y4")

func _on_Button_X4Y4_pressed():
	button_press("btn_x4y4")

#########################  				 Y axis = 3				#########################
func _on_Button_X0Y3_pressed():
	button_press("btn_x0y3")

func _on_Button_X1Y3_pressed():
	button_press("btn_x1y3")

func _on_Button_X2Y3_pressed():
	button_press("btn_x2y3")

func _on_Button_X3Y3_pressed():
	button_press("btn_x3y3")

func _on_Button_X4Y3_pressed():
	button_press("btn_x4y3")

#########################  				 Y axis = 2				#########################
func _on_Button_X0Y2_pressed():
	button_press("btn_x0y2")

func _on_Button_X1Y2_pressed():
	button_press("btn_x1y2")

func _on_Button_X2Y2_pressed():
	button_press("btn_x2y2")

func _on_Button_X3Y2_pressed():
	button_press("btn_x3y2")
	
func _on_Button_X4Y2_pressed():
	button_press("btn_x4y2")

#########################  				 Y axis = 1				#########################
func _on_Button_X0Y1_pressed():
	button_press("btn_x0y1")

func _on_Button_X1Y1_pressed():
	button_press("btn_x1y1")

func _on_Button_X2Y1_pressed():
	button_press("btn_x2y1")

func _on_Button_X3Y1_pressed():
	button_press("btn_x3y1")

func _on_Button_X4Y1_pressed():
	button_press("btn_x4y1")

#########################  				 Y axis = 0				#########################
# X0Y0 does not exist beacuse it is the start

func _on_Button_X1Y0_pressed():
	button_press("btn_x1y0")

func _on_Button_X2Y0_pressed():
	button_press("btn_x2y0")
	
func _on_Button_X3Y0_pressed():
	button_press("btn_x3y0")

func _on_Button_X4Y0_pressed():
	button_press("btn_x4y0")







