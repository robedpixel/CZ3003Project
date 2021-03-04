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

var button_grid = [] # the maze to be created
var boss_exists  # Boolean to see if the boss already exits
var store_exists  # Boolean to see if the store already exits
var height=5  # height of the map
var width=5   # width of the map

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_layout(height,width)
	initial_button_text()
	boss_exists = false
	store_exists = false
	print(button_grid)
	

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
		0 : return "void"
		1 : return "easy"
		2 : return "meduim"
		3 : return "hard"
		4 : return "boss"
		5 : return "store"
		6 : return "start"
		_ : return "error"

# function to set the state, the parameter state refers to button state
func set_state_int(state):
	if state<5:
		check_for_boss_existence()
		check_for_store_existence()
		print("Boss: ", boss_exists, " Store: ", store_exists)
		
		if(state==3 and boss_exists==true):
			print("boss exist")
			state=set_state_int(4)
			return state
		elif(state==4 && store_exists==true):
			print("store exist")
			state= 0
			return state
		else: state=state+1
		return state
	else: 
		check_for_boss_existence()
		check_for_store_existence()
		print("Boss: ", boss_exists, " Store: ", store_exists)
		state=0
		return state

# function to check if the boss already exist in the maze, if exists the boss_exists = true
func check_for_boss_existence():
	for x in range(width):
		for y in range(height):
			if(button_grid[x][y]==4):
				boss_exists=true
				return
	boss_exists=false
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


func button_press(var button_name):
	var x = buttons_dict[button_name][1]
	var y = buttons_dict[button_name][2]
	var button_node = get_node(buttons_dict[button_name][0])
	
	button_grid[x][y] = set_state_int(button_grid[x][y])
	button_node.text= get_state_name(button_grid[x][y])
	print(button_grid)

func _on_Button_X0Y4_pressed():
	button_press("btn_x0y4")

func _on_Button_X1Y4_pressed():
	button_press("btn_x1y4")

func _on_Button_X0Y3_pressed():
	button_press("btn_x0y3")

func _on_Button_X1Y3_pressed():
	button_press("btn_x1y3")
