extends KinematicBody2D

export (int) var speed = 200

const FLOAT_EPSILON = 0.00001

onready var cmbtManager = get_node("../CombatManager")
onready var mazeManager = get_node("../Maze")
onready var healthUI = get_node("../MainCanvas/Hearts")
onready var coinUI = get_node("../MainCanvas/MainUI/CoinsUI")
onready var itemUI = get_node("../MainCanvas/MainUI/ItemUI/ItemUIBG/Item")

var velocity = Vector2()
onready var playerSprite = $PlayerSprite

var canInteract = false
var interactObjList = []

var movingRight = false
var right = false
var isMoving : bool = false

# throw all the stats here, 
var maxHealth = 0
var health = 0
var coins = 0

var inventory = []
var currentInventoryIndex = 0

#signals
signal coin_change_signal(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.append(GlobalVariables.ItemEnum.ITEM_HEALTHPOT)
	_showItem()
	pass

func _initPlayer(startingHealth, startingCoins):
	_initHealth(startingHealth)
	_setCoins(startingCoins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	if(!isMoving):
#		playerSprite.playing = false
		playerSprite.speed_scale = 0.3
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
	canInteract = true
	self.interactObjList.append(interactObjName)
	#print(self.interactObjList)
	
func _RemoveInteractable(interactObjName):
	canInteract = false
	var i = self.interactObjList.find(interactObjName)
	self.interactObjList.remove(i)
	#print(self.interactObjList)
	
# interact with the latest interactable obj
# no observer pattern, throwing all here
func _interact():
	if(interactObjList.size() > 0):
		var interactObj = interactObjList[interactObjList.size() - 1]
		print("interacting with " + interactObj.name)
		
		interactObj._interact(self)
		
		#if('Door' in interactObj):
			#mazeManager._moveRoom(interactObj.name)
		#elif('Monster' in interactObj):
			#cmbtManager._enterCombat()
		#elif('ShopItem' in interactObj):
			
		
		#var interactObjType = get_node("../Interactables/" + interactObjName).get_meta("type")
		#print(interactObjType)
		# lazy, lets just do a switch here
		# godot no switch, use match
#		match interactObjType:
#			"monster":
#				cmbtManager._enterCombat()
#			"door":
#				mazeManager._moveRoom(interactObjName)

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
		return
	
	var item = inventory[currentInventoryIndex]
	
	# remove from inventory
	inventory.erase(item)
	_nextItem()
	
	match item:
		GlobalVariables.ItemEnum.ITEM_HEALTHPOT:
			_restoreHealth(3)
		1:
			pass
		_:
			pass
	
func _addItem(itemType):
	inventory.append(itemType)
	
	
	


