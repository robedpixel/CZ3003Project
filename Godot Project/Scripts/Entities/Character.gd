extends KinematicBody2D

export (int) var speed = 200

const FLOAT_EPSILON = 0.00001

onready var cmbtManager = get_node("../CombatManager")
onready var mazeManager = get_node("../Maze")
onready var healthUI = get_node("../MainCanvas/Hearts")
onready var coinUI = get_node("../MainCanvas/MainUI/CoinsUI")
onready var itemUI = get_node("../MainCanvas/MainUI/ItemUI/ItemUIBG/Item")
onready var transition = get_node("../Transition")
onready var dialogueManager = get_node("/root/Main/DialogueCanvas")

var velocity = Vector2()
onready var playerSprite = $PlayerSprite

var lock : bool = false
var interactObjList = []

var movingRight = false
var right = false
var isMoving : bool = false
var lockFrame : bool = false

var idleAnimSpeed = 0.3

# throw all the stats here, 
var maxHealth = 0
var health = 0
var coins = 0
var attack = 1

var inventory = []
var currentInventoryIndex = 0

var portrait

#signals
signal coin_change_signal(value)
signal player_hurt_signal(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.append(GlobalVariables.ItemEnum.ITEM_HEALTHPOT)
	_showItem()
	connect("player_hurt_signal", transition, "_hurtFlash")

func _initPlayer(startingHealth, startingAttack, startingCoins, charType):
	_initHealth(startingHealth)
	_setCoins(startingCoins)
	attack = startingAttack
	
	match charType:
		0:
			portrait = load("res://Resources/images/Character/Drawing/character3.png")
			playerSprite.set_sprite_frames(load("res://Scenes/Prefabs/player_warrior.tres"))
			idleAnimSpeed = 0
		1:
			portrait = load("res://Resources/images/Character/Drawing/character2.png")
			playerSprite.set_sprite_frames(load("res://Scenes/Prefabs/player_average.tres"))
			idleAnimSpeed = 0
		2:
			portrait = load("res://Resources/images/Character/Drawing/character1.png")
			playerSprite.set_sprite_frames(load("res://Scenes/Prefabs/player_thief.tres"))
			idleAnimSpeed = 0.3
		_:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(lock):
		return
	
	if(lockFrame):
		lockFrame = false
		return
	
	if Input.is_action_just_pressed('interact'):
		_interact()
	
	if(Input.is_action_just_pressed("next_item")):
		_nextItem()
		
	if(Input.is_action_just_pressed("use_item")):
		_useItem()
		
	_processAnimation()
	
#	if(movingRight):
#		if(not right):
#			apply_scale(Vector2(-1, 1))
#		right = true
#	elif(not movingRight):
#		if(right):
#			apply_scale(Vector2(-1, 1))
#		right = false

func _processAnimation():
	if(!isMoving or lockFrame):
#		playerSprite.playing = false
		playerSprite.speed_scale = idleAnimSpeed
		if(idleAnimSpeed == 0):
			playerSprite.frame = 0
		return
	else:
		playerSprite.playing = true
		playerSprite.speed_scale = 1.5
		
	if(velocity.x > FLOAT_EPSILON):
		playerSprite.play("right")
	elif(velocity.x < -FLOAT_EPSILON):
		playerSprite.play("left")
	elif(velocity.y > FLOAT_EPSILON):
		playerSprite.play("down")
	elif(velocity.y < -FLOAT_EPSILON):
		playerSprite.play("up")

func get_input():
	if(lock):
		return
	
	
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity = Vector2(1, 0)
	if Input.is_action_pressed('left'):
		velocity = Vector2(-1, 0)
	if Input.is_action_pressed('down'):
		velocity = Vector2(0, 1)
	if Input.is_action_pressed('up'):
		velocity = Vector2(0, -1)
	
	if(velocity.x < FLOAT_EPSILON and velocity.x > -FLOAT_EPSILON and 
	velocity.y < FLOAT_EPSILON and velocity.y > -FLOAT_EPSILON):
		isMoving = false
	else:
		isMoving = true
	
	velocity = velocity.normalized() * speed
	
	if(velocity.x > FLOAT_EPSILON):
		movingRight = true
	elif(velocity.x < -FLOAT_EPSILON):
		movingRight = false
	#print(velocity)
	#print(right)

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
func _AddInteractable(interactObjName):
	self.interactObjList.append(interactObjName)
	#print(self.interactObjList)
	
func _RemoveInteractable(interactObjName):
	var i = self.interactObjList.find(interactObjName)
	self.interactObjList.remove(i)
	#print(self.interactObjList)
	
# interact with the latest interactable obj
# no observer pattern, throwing all here
func _interact():
	if(interactObjList.size() > 0):
		var interactObj = interactObjList[interactObjList.size() - 1]
		print("interacting with " + interactObj.name)
		
		var result = interactObj._interact(self)
		
		if(result != ""):
			lock = true
			dialogueManager._dialoguePlayer(portrait, result, true)
			#dialogueUI._showDialogueBox(true)
			#dialogueUI._showPortrait(true)
			#dialogueUI._showPlayerPortrait(portrait)
			#dialogue._displayDialogueClosable(result)

func _disableAndHide():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	playerSprite.visible = false
	
func _enable():
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	playerSprite.visible = true
	
# could make an empty node and attach a player health to it.
func _initHealth(initHealth):
	maxHealth = initHealth
	health = maxHealth
	healthUI._initHeartUI(maxHealth)

func _restoreHealth(healthRestored):
	health += healthRestored
	if(health >= maxHealth):
		health = maxHealth
	healthUI._setHeart(health, maxHealth)

func _takeDamage(damageTaken):
	if(health <= 0):
		return
		
	health -= damageTaken
	healthUI._setHeart(health, maxHealth)
	
	emit_signal("player_hurt_signal")
	
	if(health <= 0):
		print("Game over")
		return
	

# could make an empty node and add playerInventory or playerCoins to it
func _setCoins(coinsToSet):
	coins = coinsToSet
	emit_signal("coin_change_signal", coins)

func _addCoins(coinsToAdd):
	_setCoins(coins+coinsToAdd)
	
func _removeCoins(coinsToRemove):
	_setCoins(coins-coinsToRemove)
	
func _getCoins():
	return coins
	
# could make an empty node and add playerInventory to it
# can decouple UI logic from player. Use observer pattern to see if currentInventoryIndex has changed
func _nextItem():
	if(inventory.size() <= 0):
		itemUI._setItem(GlobalVariables.ItemEnum.ITEM_NULL)
		currentInventoryIndex = 0
		return
	
	currentInventoryIndex += 1
	if(currentInventoryIndex >= inventory.size()):
		currentInventoryIndex = 0
	
	_showItem()
	
func _showItem():
	itemUI._setItem(inventory[currentInventoryIndex])
	#itemUI._disableCollider()
	
# can move item logic outside of player
func _useItem():
	if(inventory.size() <= 0):
		print("No items to use")
		currentInventoryIndex = 0
		return
	
	var item = inventory[currentInventoryIndex]
	
	match item:
		GlobalVariables.ItemEnum.ITEM_HEALTHPOT:
			if(health == maxHealth):
				#dialogueManager._dialoguePlayer(portrait, "Already at max hp", true)
				return
			_restoreHealth(3)
		1:
			pass
		_:
			pass
			
	# remove from inventory
	inventory.erase(item)
	_nextItem()
			
	$ItemUseAudio.play()
	
func _addItem(itemType):
	inventory.append(itemType)
	_showItem()
	
func _lockCharacter(lock):
	self.lock = lock
	lockFrame = true
	
	
	


