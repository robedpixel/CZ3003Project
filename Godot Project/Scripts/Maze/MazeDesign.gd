extends Node

var WIDTH
var HEIGHT

var layout

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# set the 2d array layout variable
func _setMaze(newLayout):
	layout = newLayout

func _validateLayout():
	for x in range(WIDTH):
		for y in range(HEIGHT):
			layout[x][y] = int(layout[x][y])

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
		return GlobalVariables.RoomEnum.VOID_ROOM # -1 for error
	return layout[x][y]

func _setRoom(x, y, value):			
	if(x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT or value < GlobalVariables.RoomEnum.VOID_ROOM or value >= GlobalVariables.RoomEnum.MAX_ROOM_ENUM):
		print("Error setting room " + str(x) + " " + str(y) + " " + str(value))
	
	layout[x][y] = value
	print("Setting room " + str(x) + " " + str(y) + " " + str(value))
	
	
