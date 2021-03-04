extends GridContainer

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

var button_grid = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var height=5
	var width=5
	generate_layout(height,width)
	initial_button_text()
	
	print(button_grid)
	

func generate_layout(var height,var width):
	for x in range(width):
		button_grid.append([])
		for y in range(height):
			button_grid[x].append([])
			if(x==0 and y==0):
				button_grid[x][y]=6
			else:
				button_grid[x][y]=0

func initial_button_text():
	print(len(buttons_dict))
	for key in buttons_dict.keys():
		var button_node = get_node(buttons_dict[key][0])
		var x = buttons_dict[key][1]
		var y = buttons_dict[key][2]
		
		button_node.text=get_state_name(button_grid[x][y])
	


#funtion to get the name of the state
func get_state_name(state):
	if state ==0: return "void"
	elif state ==1: return "easy"
	elif state ==2: return "meduim"
	elif state ==3: return "hard"
	elif state ==4: return "boss"
	elif state ==5: return "store"
	elif state ==6: return "start"
	else: ""

# function to set the state, the parameter state refers to button state
func set_state_int(state):
	if state<5:
		state=state+1
		return state
	else: 
		state=0
		return state

func button_press(var button_name):
	var x = buttons_dict[button_name][1]
	var y = buttons_dict[button_name][2]
	var button_node = get_node(buttons_dict[button_name][0])
	
	button_grid[x][y] = set_state_int(button_grid[x][y])
	button_node.text= get_state_name(button_grid[x][y])
	print(button_grid)

func _on_Button_X0Y4_pressed():
	button_press("btn_x0y4")
