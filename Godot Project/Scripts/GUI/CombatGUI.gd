extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cmbtManager = get_node('/root/Main/CombatManager')

onready var dialogueUI = get_node("/root/Main/DialogueCanvas/DialogueUI")

onready var dialogue = get_node("/root/Main/DialogueCanvas/DialogueUI/DialogueBox")

onready var background = $BG

var weaponSlash = preload("res://Scenes/Prefabs/WeaponSlash.tscn")

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
	if(!tween.is_active()):
		tween_lock = false
#	if(displayQn):
#		currentQnTxt = currentQnTxt + combatQuestion.question[txtIndex]
#		txtIndex += 1
#		questionLabel.text = currentQnTxt
#		if(txtIndex >= combatQuestion.question.length()):
#			displayQn = false
#			_displayAnswers()

func _toggle(show):
	if(show):
		_show()
	else:
		_hide()

func _show():
	self.visible = true

func _hide():
	self.visible = false

func _hideAnswers():
	for x in range(4):
		answers[x].visible = false

func _showAns(index):
	answers[index].visible = true

func _setQuestion(combatQuestionToSet):
	combatQuestion = combatQuestionToSet
	ans1.text = combatQuestion.answer_a
	ans2.text = combatQuestion.answer_b
	ans3.text = combatQuestion.answer_c
	ans4.text = combatQuestion.answer_d
	
func _displayQn():
	currentQnTxt = ""
	txtIndex = 0
	#displayQn = true
	dialogueUI._showDialogueBox(true)
	dialogue._displayDialogue(combatQuestion.question)
	_hideAnswers()

func _displayAnswers():
	tween_lock = true
	var delay = 0.25
	for x in range(4):
		tween.interpolate_callback(self, delay, "_showAns", x)
		tween.start()
		delay += 0.25
		


func _on_Button_pressed(index):
	if(tween_lock):
		return
		
	cmbtManager._onAnswer(index)
	
func _onDialogueTextEnd():
	_displayAnswers()
	
func _showPortrait(show):
	dialogueUI._showPortrait(show)

func _showDialogueBox(show):
	dialogueUI._showDialogueBox(show)
	
func _weaponSlashAnimation(monsterPosition):
	var weaponSlashInstance = weaponSlash.instance()
	
	weaponSlashInstance.set_position(monsterPosition)
	
	add_child(weaponSlashInstance)
