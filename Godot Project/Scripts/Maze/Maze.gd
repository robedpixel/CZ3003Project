extends Node


onready var mazeDesign = get_node("../MazeDesign")

onready var player = get_node("../Player")

# interactables, door
onready var leftDoor = get_node("../Interactables/LeftDoor")
onready var rightDoor = get_node("../Interactables/RightDoor")
onready var upDoor = get_node("../Interactables/UpDoor")
onready var downDoor = get_node("../Interactables/DownDoor")

# UI
onready var gridLocationTxt = get_node("../MainUI/GridLocationBackground/GridLocationText")

var playerX = 0
var playerY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_initializeMaze()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Generate maze depending on input. 
# Set player, boss and shop spawn
func _initializeMaze():
	mazeDesign._generateMaze(5, 5)
	mazeDesign._setRoom(playerX, playerY, 4)
	mazeDesign._setRoom(4, 4, 3)
	
	_loadRoom(playerX, playerY)
	_updatePlayerGridUI()

# 0 up
# 1 down
# 2 left
# 3 right
func _moveRoom(dir):
	
	var newPlayerX = playerX
	var newPlayerY = playerY
	
	print("Moving " + dir)
	# move
	match dir:
		"UpDoor":
			newPlayerY += 1
		"DownDoor":
			newPlayerY -= 1
		"LeftDoor":
			newPlayerX -=1
		"RightDoor":
			newPlayerX += 1
		_:
			print("Unable to move, invalid direction. Door missing?")
			
	var validRoom = _checkPlayerInValidRoom(newPlayerX, newPlayerY)
	if(validRoom):
		playerX = newPlayerX
		playerY = newPlayerY
	else:
		print("Invalid room. Unable to move to " + str(newPlayerX) + " " + str(newPlayerY))
		return
		
	_loadRoom(playerX, playerY)
	_updatePlayerGridUI()
	


func _loadRoom(x, y):
	print("Loading room " + str(x) + " " + str(y))
	# retrieve data from map design.
	var roomType = mazeDesign._getRoom(x, y)
	
	var adjacentLeftRoom = mazeDesign._getRoom(x - 1, y)
	var adjacentRightRoom = mazeDesign._getRoom(x + 1, y)
	var adjacentUpRoom = mazeDesign._getRoom(x, y + 1)
	var adjacentDownRoom = mazeDesign._getRoom(x, y - 1)
	
	leftDoor._toggleDoor(true)
	rightDoor._toggleDoor(true)
	upDoor._toggleDoor(true)
	downDoor._toggleDoor(true)
	
	if(adjacentLeftRoom <= 0):
		leftDoor._toggleDoor(false)
	if(adjacentRightRoom <= 0):
		rightDoor._toggleDoor(false)
	if(adjacentUpRoom <= 0):
		upDoor._toggleDoor(false)
	if(adjacentDownRoom <= 0):
		downDoor._toggleDoor(false)
	
func _checkPlayerInValidRoom(x, y):
	var roomType = mazeDesign._getRoom(x, y)
	if(roomType == -1 or roomType == 0):
		return false
	return true
	
func _updatePlayerGridUI():
	gridLocationTxt.text = "X" + str(playerX) + "    " + "Y" + str(playerY)

