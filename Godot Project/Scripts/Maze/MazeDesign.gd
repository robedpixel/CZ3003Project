extends Node

var WIDTH
var HEIGHT

var layout

# 0 walled
# 1 challenge room
# 2 boss
# 3 shop
# 4 starting room
# 5 empty room

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# set the 2d array layout variable
func _setMaze(newLayout):
	layout = newLayout

func _generateMaze(mazeWidth, mazeHeight):
	WIDTH = mazeWidth
	HEIGHT = mazeHeight
	
	# sample maze
	layout = []
	for x in range(WIDTH):
		layout.append([])
		layout[x]=[]        
		for y in range(HEIGHT):
			layout[x].append([])
			layout[x][y]=GlobalVariables.RoomEnum.EMPTY_ROOM
			
func _getLayout():
	return layout
	
func _getRoom(x, y):
	if(x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT):
		return -1 # -1 for error
	return layout[x][y]

func _setRoom(x, y, value):			
	if(x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT or value < 0 or value > 4):
		print("Error setting room " + str(x) + " " + str(y) + " " + str(value))
	
	layout[x][y] = value
	print("Setting room " + str(x) + " " + str(y) + " " + str(value))
	
	
