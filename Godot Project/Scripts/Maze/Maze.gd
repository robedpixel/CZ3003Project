extends Node


onready var mazeDesign = get_node("../MazeDesign")
onready var player = get_node("../Player")
onready var questionManager = get_node("../QuestionManager")
onready var cmbtManager = get_node("../CombatManager")
onready var monsterFactory = get_node("../MonsterFactory")

# door
onready var leftDoor = $Doors/Left
onready var rightDoor = $Doors/Right
onready var upDoor = $Doors/Up
onready var downDoor = $Doors/Down

# UI
onready var gridLocationTxt = get_node("../MainCanvas/MainUI/GridLocationBackground/GridLocationText")

# prefabs
onready var monsterObj = preload("res://Scenes/Prefabs/Monster.tscn")
onready var bossObj = preload("res://Scenes/Prefabs/Boss.tscn")
onready var shopObj = preload("res://Scenes/Prefabs/Shop.tscn")

# player variables
var playerX = 0
var playerY = 0

var prevPlayerX = 0
var prevPlayerY = 0

# room variables
var currentRoomType
var currentMonster

var shop
var shopItems = []

var movedRoom : bool = false
var lastUsedDoor = ""

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
	
	for x in range(mazeDesign.WIDTH):
		for y in range(mazeDesign.HEIGHT):
			mazeDesign._setRoom(x, y, GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY)
	
	mazeDesign._setRoom(0, 2, GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED)
	mazeDesign._setRoom(0, 3, GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD)
	
	mazeDesign._setRoom(playerX, playerY, GlobalVariables.RoomEnum.STARTING_ROOM)
	mazeDesign._setRoom(1, 1, GlobalVariables.RoomEnum.BOSS_ROOM)
	mazeDesign._setRoom(1, 0, GlobalVariables.RoomEnum.SHOP_ROOM)
	
	_loadRoom(playerX, playerY)
	_updatePlayerGridUI()
	
	# 3 health 5 coins
	player._initPlayer(3, 5)
	
	# init shop and boss
	
	shopItems = [GlobalVariables.ItemEnum.ITEM_HEALTHPOT,
	GlobalVariables.ItemEnum.ITEM_HEALTHPOT,
	GlobalVariables.ItemEnum.ITEM_HEALTHPOT]
	
	

func _moveRoom(dir):
	
	var newPlayerX = playerX
	var newPlayerY = playerY
	
	print("Moving " + dir)
	var doorPos = Vector2(0, 0)
	# move
	match dir:
		"up":
			newPlayerY += 1
			doorPos = downDoor.area2D.position
		"down":
			newPlayerY -= 1
			doorPos = upDoor.area2D.position
		"left":
			newPlayerX -=1
			doorPos = rightDoor.area2D.position
		"right":
			newPlayerX += 1
			doorPos = leftDoor.area2D.position
		_:
			print("Unable to move, invalid direction. Door missing?")
			
	var validRoom = _checkPlayerInValidRoom(newPlayerX, newPlayerY)
	if(validRoom):
		playerX = newPlayerX
		playerY = newPlayerY
		movedRoom = true
		lastUsedDoor = dir
	else:
		print("Invalid room. Unable to move to " + str(newPlayerX) + " " + str(newPlayerY))
		return
	
	_exitRoom()
	
	_loadRoom(playerX, playerY)
	_updatePlayerGridUI()
	player.set_position(doorPos)
	
	movedRoom = false

func _refreshRoom():
	_exitRoom()
	_loadRoom(playerX, playerY)


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
	_setLockAllDoors(false)
	
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
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY: # challenge
			_initChallengeRoom(false)
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED:
			_initChallengeRoom(false)
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD:
			_initChallengeRoom(false)
		GlobalVariables.RoomEnum.BOSS_ROOM: # boss
			_initChallengeRoom(true)
		GlobalVariables.RoomEnum.SHOP_ROOM: # shop
			_initShopRoom()
		_: # default
			pass	

func _checkPlayerInValidRoom(x, y):
	var roomType = mazeDesign._getRoom(x, y)
	if(roomType <= -1 or roomType == GlobalVariables.RoomEnum.VOID_ROOM):
		return false
	return true

func _updatePlayerGridUI():
	gridLocationTxt.text = "X" + str(playerX) + "    " + "Y" + str(playerY)

# i should turn this into a list
func _setLockAllDoors(lock):
	leftDoor._setLocked(lock)
	rightDoor._setLocked(lock)
	upDoor._setLocked(lock)
	downDoor._setLocked(lock)

func _toggleAllDoors(show):
	leftDoor._toggleDoor(show)
	rightDoor._toggleDoor(show)
	upDoor._toggleDoor(show)
	downDoor._toggleDoor(show)

func _unlockLastDoor():
	match lastUsedDoor:
		"up":
			downDoor._setLocked(false)
		"down":
			upDoor._setLocked(false)
		"left":
			rightDoor._setLocked(false)
		"right":
			leftDoor._setLocked(false)
		_:
			pass

# Clear monster/shop
func _exitRoom():
	prevPlayerX = playerX
	prevPlayerY = playerY
	if(shop):
		shop.queue_free()
	if(currentMonster):
		currentMonster.queue_free()

func _initChallengeRoom(isBoss):
	print("Init challenge room")
	
	if(movedRoom):
		_setLockAllDoors(true)
		# unlock prev door
		_unlockLastDoor()
	
	var monster
	if(!isBoss):
		var difficulty = mazeDesign._getRoom(playerX, playerY)
		monster = monsterFactory._createMonster(difficulty)
	else:
		monster = bossObj.instance()
		
	monster.set_position(Vector2(640, 360))
	add_child(monster)
	currentMonster = monster
	cmbtManager._setMonster(currentMonster)
	
	
func _initShopRoom():
	var shopInstance = shopObj.instance()
	get_node("/root/Main").add_child(shopInstance)
	shop = shopInstance
	shop._initShop()


func _on_CombatManager_victory_signal(value):
	if(value):
		# TODO reward player
		mazeDesign._setRoom(playerX, playerY, GlobalVariables.RoomEnum.EMPTY_ROOM)
	else:
		pass
