extends Node


onready var combatUI = get_node("../MainCanvas/CombatUI")

onready var player = get_node("../Player")

var correctAnswer = 1

signal combat_signal(value)
signal victory_signal(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _enterCombat(monster):
	print("Entering combat")
	print(player)
	player._disableAndHide()
	_toggleCombatUI(true)
	emit_signal("combat_signal", true)
	
func _exitCombat():
	print("Exiting combat")
	player._enable()
	_toggleCombatUI(false)
	emit_signal("combat_signal", false)
	
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
		emit_signal("victory_signal", true)
	else:
		print("Wrong answer")
		emit_signal("victory_signal", false)
		# Take enemy damage value
		# Hardcode to 1 dmg for now
		player._takeDamage(1)
	_exitCombat()
