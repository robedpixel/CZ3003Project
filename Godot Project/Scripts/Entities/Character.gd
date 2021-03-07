extends KinematicBody2D

export (int) var speed = 200

const FLOAT_EPSILON = 0.00001

onready var cmbtManager = get_node("../CombatManager")
onready var mazeManager = get_node("../Maze")
onready var healthUI = get_node("../MainCanvas/MainUI/Hearts")

var velocity = Vector2()
onready var playerSprite = $PlayerSprite

var canInteract = false
var interactObjList = []

var movingRight = false
var right = false

# throw all the stats here, 
var maxHealth = 0
var health = 0
var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('interact'):
		_interact()
	
	if(movingRight):
		if(not right):
			apply_scale(Vector2(-1, 1))
		right = true
	elif(not movingRight):
		if(right):
			apply_scale(Vector2(-1, 1))
		right = false

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
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
		
		interactObj._interact()
		
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
	health -= damageTaken
	if(health < 0):
		print("Game over")
		return
	healthUI._setHeart(health, maxHealth)
	
func _addCoins(coinsToAdd):
	coins += coinsToAdd
	
func _removeCoins(coinsToRemove):
	coins -= coinsToRemove

func _getCoins():
	return coins



