extends Node


onready var combatUI = get_node("../MainCanvas/CombatCanvas/CombatUI")

onready var player = get_node("../Player")

onready var questionManagerEasy = get_node("../QuestionManagerEasy")
onready var questionManagerMed = get_node("../QuestionManagerMed")
onready var questionManagerHard = get_node("../QuestionManagerHard")
onready var questionManagerBoss = get_node("../QuestionManagerBoss")

var correctAnswer = 1

signal combat_signal(value)
signal victory_signal(value, roomDifficulty)
signal gameover_signal(value)

var currentMonster
var isBoss : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _initTopic(topic):
	var srcEasy = "res://Resources/Questions/"
	var srcMed = "res://Resources/Questions/"
	var srcHard = "res://Resources/Questions/"
	var srcBoss = ""
	
	match topic:
		GlobalVariables.TopicEnum.TOPIC_1:
			# i should append instead
			srcEasy = "res://Resources/Questions/Requirement_Analysis_easy.json"
			srcMed = "res://Resources/Questions/Requirement_Analysis_medium.json"
			srcHard = "res://Resources/Questions/Requirement_Analysis_hard.json"
			srcBoss = "res://Resources/Questions/Requirement_Analysis_boss.json"
		GlobalVariables.TopicEnum.TOPIC_2:
			srcEasy = "res://Resources/Questions/Requirement_Elicitation_easy.json"
			srcMed = "res://Resources/Questions/Requirement_Elicitation_medium.json"
			srcHard = "res://Resources/Questions/Requirement_Elicitation_hard.json"
			srcBoss = "res://Resources/Questions/Requirement_Elicitation_boss.json"
		GlobalVariables.TopicEnum.CUSTOM_TOPIC:
			pass
		_:
			pass
	questionManagerEasy.read_questions_from_source(srcEasy)
	questionManagerEasy.prepare_questions()
	
	questionManagerMed.read_questions_from_source(srcMed)
	questionManagerMed.prepare_questions()
	
	questionManagerHard.read_questions_from_source(srcHard)
	questionManagerHard.prepare_questions()
	
	questionManagerBoss.read_questions_from_source(srcBoss)
	questionManagerBoss.prepare_questions()

func _enterCombat(monster):
	print("Entering combat")
	
	player._disableAndHide()
	
	emit_signal("combat_signal", true)

func _nextQuestion():
	var question = null
	match currentMonster.difficulty:
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY:
			question = questionManagerEasy.ask_question()
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED:
			question = questionManagerMed.ask_question()
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD:
			question = questionManagerHard.ask_question()
		GlobalVariables.RoomEnum.BOSS_ROOM:
			question = questionManagerBoss.ask_question()
		_:
			pass
	
	if(question == null):
		print("Error asking qn")
		return
	
	#print("QUESTION" + str (question.question))
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
			emit_signal("gameover_signal", false)
			return
		if(!isBoss):
			emit_signal("victory_signal", false, currentMonster.difficulty)
			combatUI._showDialogue(false)
			_exitCombat()
		else:
			_nextQuestion()

func _onAlive(entity):
	_nextQuestion()

func _onDeath(entity):
	currentMonster._deathAnim()
	combatUI._showDialogue(false);
		
	
func _monsterDeathAnimEnd():
	combatUI._showDialogue(false)
	emit_signal("victory_signal", true, currentMonster.difficulty)
	_exitCombat()
	
	if(isBoss):
		emit_signal("gameover_signal", true)

func _onTransitionShowStart():
	
	currentMonster._monsterFadeInAnim()
	
func _onTransitionShowEnd():
	
	combatUI._hideAnswers()
	_toggleCombatUI(true)
	_nextQuestion()
	combatUI.dialogueManager.dialogueUI._setMonsterPortrait(currentMonster)
	
	
