extends Node


onready var mazeDesign = get_node("../MazeDesign")
onready var player = get_node("../Player")
onready var questionManager = get_node("../QuestionManager")
onready var cmbtManager = get_node("../CombatManager")
onready var monsterFactory = get_node("../MonsterFactory")
onready var transition = get_node("../Transition")
onready var effectManager = get_node("../EffectManager")
onready var dialogueUI = get_node("/root/Main/DialogueCanvas/DialogueUI")
onready var dialogue = get_node("/root/Main/DialogueCanvas/DialogueUI/DialogueBox")
onready var mainUI = get_node("/root/Main/MainCanvas")
onready var analytics = get_node("../AnalyticsManager")

# door
onready var leftDoor = $Doors/Left
onready var rightDoor = $Doors/Right
onready var upDoor = $Doors/Up
onready var downDoor = $Doors/Down

# UI
onready var gridLocationTxt = get_node("../MainCanvas/MainUI/GridLocationBackground/GridLocationText")

# prefabs
onready var shopObj = preload("res://Scenes/Prefabs/Shop.tscn")
onready var guideBookObj = preload("res://Scenes/Prefabs/GuideBookItem.tscn")

# player variables
var playerX = 0
var playerY = 0

var prevPlayerX = 0
var prevPlayerY = 0

# room variables
var currentRoomType
var currentMonster
var currentGuideBook
var minDifficulty = GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY

var shop
var shopItems = []

var movedRoom : bool = false
var lastUsedDoor = ""
var targetDoorPos

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
	
	var topic = GlobalVariables.topic_selected
	if(topic == null):
		topic = GlobalVariables.TopicEnum.TOPIC_1
	cmbtManager._initTopic(topic)
	
	var charSelected = GlobalVariables.charSelected
	#charSelected = 0
	var health = 0
	var attack = 0
	var coins = 0
	var class_data = null
	match charSelected:
		0:
			class_data = preload("res://Resources/images/Warrior.tres")
		1:
			class_data = preload("res://Resources/images/Average.tres")
		2:
			class_data = preload("res://Resources/images/Thief.tres")
		_:
			pass
			
	if(class_data == null):
		print("Error initializing player. Setting debug player")
		player._initPlayer(30, 999, 99999, charSelected)
	else:
		player._initPlayer(class_data.health, class_data.multiplier, 0, charSelected)
	
	analytics._resetAnalytics()
	
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
	
	targetDoorPos = doorPos
	
	transition._roomFlash()

# part 2 of moveRoom()
func _moveRoomTransition():
	if(movedRoom):
		_loadRoom(playerX, playerY)
		_updatePlayerGridUI()
		player.set_position(targetDoorPos)
	
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
		GlobalVariables.RoomEnum.STARTING_ROOM:
			_initStartingRoom()
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
	if(currentGuideBook):
		currentGuideBook.queue_free()
	

func _initStartingRoom():
	var guideBookInstance = guideBookObj.instance()
	add_child(guideBookInstance)
	guideBookInstance.set_position(Vector2(640, 360))
	
	currentGuideBook = guideBookInstance

func _initChallengeRoom(isBoss):
	print("Init challenge room")
	
	if(movedRoom):
		_setLockAllDoors(true)
		# unlock prev door
		_unlockLastDoor()
	
	var monster
	if(!isBoss):
		var difficulty = mazeDesign._getRoom(playerX, playerY)
		if(difficulty < minDifficulty):
			print("DIFFICULTY CHANGE PROC " + str(difficulty) + " TO " + str(minDifficulty))
			difficulty = minDifficulty
			
		monster = monsterFactory._createMonster(difficulty)
	else:
		monster = monsterFactory._createBoss()
		
	monster.set_position(Vector2(640, 360))
	add_child(monster)
	currentMonster = monster
	cmbtManager._setMonster(currentMonster)
	
	
func _initShopRoom():
	var shopInstance = shopObj.instance()
	get_node("/root/Main").add_child(shopInstance)
	shop = shopInstance
	shop._initShop()


func _on_CombatManager_victory_signal(value, difficulty):
	if(value):
		_rewardPlayer()
		mazeDesign._setRoom(playerX, playerY, GlobalVariables.RoomEnum.EMPTY_ROOM)
	else:
		pass

# 

# attack 2, 3
# Multiplier 1.0, 1.2, 1.4

# Monster difficulty, easy, med , hard
# Multiplier 1.0, 1.5, 2.0
func _rewardPlayer():
	if(!currentMonster):
		return
	
	var base = 1.0
	
	var attackMultiplier = 1.25
	var difficultyMultiplier = 1.0
	
	match currentMonster.difficulty:
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY:
			difficultyMultiplier = GlobalVariables.monsterDifficultyRewardModifier["EASY"]
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED:
			difficultyMultiplier = GlobalVariables.monsterDifficultyRewardModifier["MED"]
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD:
			difficultyMultiplier = GlobalVariables.monsterDifficultyRewardModifier["HARD"]
		GlobalVariables.RoomEnum.BOSS_ROOM:
			difficultyMultiplier = GlobalVariables.monsterDifficultyRewardModifier["BOSS"]
		_:
			pass
	
	match player.attack:
		2: 
			attackMultiplier = 1.5
		3:
			attackMultiplier = 1.75
		_:
			pass
	
	var rewardedCoins = int(base * attackMultiplier * difficultyMultiplier)
	
	print("Rewarding " + str(attackMultiplier) + " " + str(difficultyMultiplier))
	
	player._addCoins(rewardedCoins)
	
	effectManager._playCoinAnim(currentMonster.get_position(), rewardedCoins)

func _difficultyChange(prevDifficulty, newDifficulty):
	
	var difficultyChangeTxt = ""
	
	if(newDifficulty > prevDifficulty):
		difficultyChangeTxt = "You feel a stronger presence"
	else:
		difficultyChangeTxt = "You feel less pressure from your surroundings"
		
	player._lockCharacter(true)
	dialogueUI._showDialogueBox(true)
	dialogueUI._showPortrait(true)
	dialogueUI._showPlayerPortrait(player.portrait)
	dialogue._displayDialogueClosable(difficultyChangeTxt)
	
	minDifficulty = newDifficulty


func _on_CombatManager_gameover_signal(value):
	
	player._lockCharacter(true)
	
	var gameOver = load("res://Scenes/Game_Over/Game_Over.tscn").instance()
	mainUI.add_child(gameOver)
	gameOver._saveScore(player.coins)

	
