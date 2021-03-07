extends Node


onready var mazeDesign = get_node("../MazeDesign")
onready var player = get_node("../Player")

# interactables, door
onready var interactables = get_node("../Interactables")
onready var leftDoor = get_node("../Interactables/LeftDoor")
onready var rightDoor = get_node("../Interactables/RightDoor")
onready var upDoor = get_node("../Interactables/UpDoor")
onready var downDoor = get_node("../Interactables/DownDoor")

# UI
onready var gridLocationTxt = get_node("../MainCanvas/MainUI/GridLocationBackground/GridLocationText")

# prefabs
onready var monsterObj = preload("res://Scenes/Prefabs/Monster.tscn")
onready var shopObj = preload("res://Scenes/Prefabs/Shop.tscn")

# player variables
var playerX = 0
var playerY = 0

# room variables
var currentRoomType
var currentMonster

var shop
var shopItems = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_initializeMaze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Generate maze depending on input. 
# Set player, boss and shop spawn
func _initializeMaze():
	_exitRoom()
	
	mazeDesign._generateMaze(5, 5)
	mazeDesign._setRoom(playerX, playerY, 4)
	mazeDesign._setRoom(4, 4, 3)
	
	_loadRoom(playerX, playerY)
	_updatePlayerGridUI()
	
	player._initPlayer(3, 5)
	
	# init shop and boss
	
	shopItems = [GlobalVariables.ItemEnum.ITEM_HEALTHPOT,
	GlobalVariables.ItemEnum.ITEM_HEALTHPOT,
	GlobalVariables.ItemEnum.ITEM_HEALTHPOT]
	
	

func _moveRoom(dir):
	
	_exitRoom()
	
	var newPlayerX = playerX
	var newPlayerY = playerY
	
	print("Moving " + dir)
	var doorPos = Vector2(0, 0)
	# move
	match dir:
		"up":
			newPlayerY += 1
			doorPos = downDoor.position
		"down":
			newPlayerY -= 1
			doorPos = upDoor.position
		"left":
			newPlayerX -=1
			doorPos = rightDoor.position
		"right":
			newPlayerX += 1
			doorPos = leftDoor.position
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
	player.set_position(doorPos)
	


func _loadRoom(x, y):
	print("Loading room " + str(x) + " " + str(y))
	
	# retrieve data from map design.
	var roomType = mazeDesign._getRoom(x, y)
	
	# display error room
	if(roomType == -1):
		_toggleAllDoors(false)
		return
	
	# show/hide doors accordingly
	var adjacentLeftRoom = mazeDesign._getRoom(x - 1, y)
	var adjacentRightRoom = mazeDesign._getRoom(x + 1, y)
	var adjacentUpRoom = mazeDesign._getRoom(x, y + 1)
	var adjacentDownRoom = mazeDesign._getRoom(x, y - 1)
	
	_toggleAllDoors(true)
	
	
	if(adjacentLeftRoom <= 0):
		leftDoor._toggleDoor(false)
	if(adjacentRightRoom <= 0):
		rightDoor._toggleDoor(false)
	if(adjacentUpRoom <= 0):
		upDoor._toggleDoor(false)
	if(adjacentDownRoom <= 0):
		downDoor._toggleDoor(false)
	
	# show/hide monsters/shops accordingly
	match roomType:
		1: # challenge
			_initChallengeRoom(false)
		2: # boss
			_initChallengeRoom(true)
		3: # shop
			_initShopRoom()
		_: # default
			pass	

func _checkPlayerInValidRoom(x, y):
	var roomType = mazeDesign._getRoom(x, y)
	if(roomType == -1 or roomType == 0):
		return false
	return true
	
func _updatePlayerGridUI():
	gridLocationTxt.text = "X" + str(playerX) + "    " + "Y" + str(playerY)

func _toggleAllDoors(show):
	leftDoor._toggleDoor(show)
	rightDoor._toggleDoor(show)
	upDoor._toggleDoor(show)
	downDoor._toggleDoor(show)

# Clear monster/shop
func _exitRoom():
	if(shop):
		
		shop.queue_free()
	if(currentMonster):
		currentMonster.queue_free()

func _initChallengeRoom(isBoss):
	print("Init challenge room")
	var monster = monsterObj.instance()
	monster.set_position(Vector2(640, 360))
	interactables.add_child(monster)
	currentMonster = monster
	
func _initShopRoom():
	var shopInstance = shopObj.instance()
	get_node("/root/Main").add_child(shopInstance)
	shop = shopInstance
	shop._initShop()
