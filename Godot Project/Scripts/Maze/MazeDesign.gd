extends Node

var WIDTH
var HEIGHT

var layout

# 0 empty room
# 1 challenge room
# 2 shop
# 3 boss
# 4 starting room

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# set the layout variable
func _setMaze():
	pass

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
			layout[x][y]=1
			
			
func _getLayout():
	return layout
	
func _getRoom(x, y):
	if(x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT):
		return -1 # -1 for error
	return layout[x][y]
			
func _setRoom(x, y, value):			
	if(x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT or value < 0 or value > 4):
		print("Error setting room " + str(x) + " " + str(y) + " " + str(value))
	
	print("B")
	print(layout)
	#layout[x][y] = value
	
	
