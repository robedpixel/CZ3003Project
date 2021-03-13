extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cmbtManager = get_node('../../CombatManager')

onready var questionLabel = $Label

# can godot do array? 
onready var ans1 = $Control/Button/Label
onready var ans2 = $Control2/Button/Label
onready var ans3 = $Control3/Button/Label
onready var ans4 = $Control4/Button/Label

onready var answers = [$Control/Button, $Control2/Button, $Control3/Button, $Control4/Button]

onready var tween : Tween = $Tween

var tween_lock : bool = false
var displayQn : bool = false
var currentQnTxt 
var txtIndex : int = 0

var combatQuestion : CombatQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(displayQn):
		currentQnTxt = currentQnTxt + combatQuestion.question[txtIndex]
		txtIndex += 1
		questionLabel.text = currentQnTxt
		if(txtIndex >= combatQuestion.question.length()):
			displayQn = false
			_displayAnswers()

func _toggle(show):
	if(show):
		_show()
	else:
		_hide()

func _show():
	self.visible = true

func _hide():
	self.visible = false

func _on_Button1_pressed():
	cmbtManager._onAnswer(1)

func _on_Button2_pressed():
	cmbtManager._onAnswer(2)


func _on_Button3_pressed():
	cmbtManager._onAnswer(3)


func _on_Button4_pressed():
	cmbtManager._onAnswer(4)
	
func _hideAnswers():
	for x in range(4):
		answers[x].visible = false

func _showAns(index):
	answers[index].visible = true

func _setQuestion(combatQuestionToSet):
	combatQuestion = combatQuestionToSet
	questionLabel.text = combatQuestion.question
	ans1.text = combatQuestion.answer_a
	ans2.text = combatQuestion.answer_b
	ans3.text = combatQuestion.answer_c
	ans4.text = combatQuestion.answer_d
	
func _displayQn():
	currentQnTxt = ""
	txtIndex = 0
	displayQn = true


func _displayAnswers():
	for x in range(4):
		tween.interpolate_callback(self, 0.3, "_showAns", x)
		tween.start()
		yield(tween, "tween_completed")
		
