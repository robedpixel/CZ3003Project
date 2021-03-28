extends Node


onready var combatUI = get_node("../MainCanvas/CombatCanvas/CombatUI")

onready var player = get_node("../Player")

onready var questionManagerEasy = get_node("../QuestionManagerEasy")
onready var questionManagerMed = get_node("../QuestionManagerMed")
onready var questionManagerHard = get_node("../QuestionManagerHard")
onready var questionManagerBoss = get_node("../QuestionManagerBoss")
onready var analytics = get_node("../AnalyticsManager")

var correctAnswer = 1

signal combat_signal(value)
signal victory_signal(value, roomDifficulty)
signal gameover_signal(value)

var currentMonster
var isBoss : bool = false

var src1Easy = "res://Resources/Questions/Requirement_Analysis_easy.json"
var src1Med = "res://Resources/Questions/Requirement_Analysis_medium.json"
var src1Hard = "res://Resources/Questions/Requirement_Analysis_hard.json"
var src1Boss = "res://Resources/Questions/Requirement_Analysis_boss.json"

var src2Easy = "res://Resources/Questions/Requirement_Elicitation_easy.json"
var src2Med = "res://Resources/Questions/Requirement_Elicitation_medium.json"
var src2Hard = "res://Resources/Questions/Requirement_Elicitation_hard.json"
var src2Boss = "res://Resources/Questions/Requirement_Elicitation_boss.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _initTopic(topic):
	questionManagerEasy.clear_questions_array()
	questionManagerMed.clear_questions_array()
	questionManagerHard.clear_questions_array()
	questionManagerBoss.clear_questions_array()
	
	match topic:
		GlobalVariables.TopicEnum.TOPIC_1:
			questionManagerEasy.read_questions_from_source(src1Easy)		
			questionManagerMed.read_questions_from_source(src1Med)
			questionManagerHard.read_questions_from_source(src1Hard)
			questionManagerBoss.read_questions_from_source(src1Boss)
		GlobalVariables.TopicEnum.TOPIC_2:
			questionManagerEasy.read_questions_from_source(src2Easy)		
			questionManagerMed.read_questions_from_source(src2Med)
			questionManagerHard.read_questions_from_source(src2Hard)
			questionManagerBoss.read_questions_from_source(src2Boss)
		GlobalVariables.TopicEnum.CUSTOM_TOPIC:
			questionManagerEasy.read_questions_from_source(src1Easy)		
			questionManagerMed.read_questions_from_source(src1Med)
			questionManagerHard.read_questions_from_source(src1Hard)
			questionManagerBoss.read_questions_from_source(src1Boss)
			questionManagerEasy.add_questions_from_source(src2Easy)		
			questionManagerMed.add_questions_from_source(src2Med)
			questionManagerHard.add_questions_from_source(src2Hard)
			questionManagerBoss.add_questions_from_source(src2Boss)
		_:
			pass
	
	questionManagerEasy.prepare_questions()
	questionManagerMed.prepare_questions()
	questionManagerHard.prepare_questions()
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
	#if(true):
	if(ansValue == correctAnswer):
		print("You got it correct!")
		analytics.update_question_correct(currentMonster.difficulty)

		currentMonster.monsterHealth._minusHealth(1)		
		combatUI._weaponSlashAnimation(currentMonster.position)
		combatUI._hideAnswers()
		if(isBoss):
			currentMonster._setShake(2)
			currentMonster.start_shake_tween()
	else:
		print("Wrong answer")
		analytics.update_question_wrong(currentMonster.difficulty)
		player._takeDamage(1)
		if(player.health <= 0):
			_exitCombat()
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
	
	if(isBoss):
		emit_signal("gameover_signal", true)
	
	_exitCombat()

func _onTransitionShowStart():
	
	currentMonster._monsterFadeInAnim()
	
func _onTransitionShowEnd():
	
	combatUI._hideAnswers()
	_toggleCombatUI(true)
	_nextQuestion()
	combatUI.dialogueManager.dialogueUI._setMonsterPortrait(currentMonster)
	
	
