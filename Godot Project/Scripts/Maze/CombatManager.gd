extends Node


onready var combatUI = get_node("../MainCanvas/CombatCanvas/CombatUI")

onready var player = get_node("../Player")

onready var questionManager = get_node("../QuestionManager")

var correctAnswer = 1

signal combat_signal(value)
signal victory_signal(value)
signal gameover_signal

var currentMonster
var isBoss : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	questionManager.read_questions_from_source("res://Resources/Questions/Requirement_Analysis.json")
	questionManager.prepare_questions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _enterCombat(monster):
	print("Entering combat")
	
	player._disableAndHide()
	
	emit_signal("combat_signal", true)

func _nextQuestion():
	var question = questionManager.ask_question()
	combatUI._setQuestion(question)
	
	correctAnswer = question.correct_answer
	
	combatUI._displayQn()

func _setMonster(monster):
	currentMonster = monster
	if(currentMonster.monsterHealth.maxHealth == 4):
		isBoss = true
	else:
		isBoss = false
	
func _exitCombat():
	print("Exiting combat")
	player._enable()
	
	_toggleCombatUI(false)
	combatUI._showPortrait(false)
	combatUI.dialogueUI._showDialogueBox(false)
	
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
	if(true):
	#if(ansValue == correctAnswer):
		print("You got it correct!")
		currentMonster.monsterHealth._minusHealth(1)		
		combatUI._weaponSlashAnimation(currentMonster.position)
		combatUI._hideAnswers()
		if(isBoss):
			currentMonster._setShake(2)
			currentMonster.start_shake_tween()
	else:
		print("Wrong answer")
		player._takeDamage(1)
		if(player.health <= 0):
			emit_signal("gameover_signal")
			return
		if(!isBoss):
			emit_signal("victory_signal", false)
			
			_exitCombat()
		else:
			_nextQuestion()

func _onAlive(entity):
	_nextQuestion()

func _onDeath(entity):
	currentMonster._deathAnim()
	
func _monsterDeathAnimEnd():
	emit_signal("victory_signal", true)
	_exitCombat()

func _onTransitionShowStart():
	currentMonster._monsterFadeInAnim()
	
func _onTransitionShowEnd():
	combatUI._hideAnswers()
	_toggleCombatUI(true)
	_nextQuestion()
	combatUI.dialogueUI._showPortrait(true)
	combatUI.dialogueUI._setMonsterPortrait(currentMonster)
	
	
