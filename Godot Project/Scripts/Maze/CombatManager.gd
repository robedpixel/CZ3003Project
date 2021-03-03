extends Node


onready var combatUI = get_node("../MainCanvas/CombatUI")

onready var player = get_node("../Player")

var correctAnswer = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _enterCombat():
	print("Entering combat")
	print(player)
	player._disableAndHide()
	_toggleCombatUI(true)
	
func _exitCombat():
	print("Exiting combat")
	player._enable()
	_toggleCombatUI(false)
	
func _toggleCombatUI(show):
	if(show):
		combatUI._show()
	else:
		combatUI._hide()	

# Button callback,
# ansValue will take on values 1, 2, 3, 4
func _onAnswer(ansValue):
	print('Chosen ans ' + str(ansValue))
	if(ansValue == correctAnswer):
		print("You got it correct!")
	else:
		print("Wrong answer")
		# Take enemy damage value
		# Hardcode to 1 dmg for now
		player._takeDamage(1)
	_exitCombat()