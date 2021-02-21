extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
onready var playerSprite = $PlayerSprite

var canInteract = false
var interactObjList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('interact'):
		_interact()
	pass

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

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
func _AddInteractable(interactObjName):
	canInteract = true
	self.interactObjList.append(interactObjName)
	print(self.interactObjList)
	
func _RemoveInteractable(interactObjName):
	canInteract = false
	var i = self.interactObjList.find(interactObjName)
	self.interactObjList.remove(i)
	print(self.interactObjList)
	
# interact with the latest interactable obj
func _interact():
	if(interactObjList.size() > 0):
		var interactObjName = interactObjList[interactObjList.size() - 1]
		print("interacting with " + interactObjName)
		
		var interactObjType = get_node("../Interactables/" + interactObjName).get_meta("type")
		print(interactObjType)
		# lazy, lets just do a switch here
		# godot no switch, use match
		match interactObjType:
			"monster":
				get_node("../CombatManager")._enterCombat()

func _disableAndHide():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	playerSprite.visible = false
	





