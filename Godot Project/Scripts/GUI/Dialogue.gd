extends Node



onready var dialogueLabel = $Label
onready var dialogueUI = get_node("..")
onready var player = get_node("/root/Main/Player")

var displayingDialogue : bool = false
var dialogueEnd : bool = false
var closable : bool = false
var txtIndex : int = 0
var currentDialogueTxt = ""

var fullDialogueTxt = ""

signal dialogueEndSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("dialogueEndSignal", get_node("/root/Main/MainCanvas/CombatCanvas/CombatUI"), "_onDialogueTextEnd")

func _process(delta):
	if(displayingDialogue):
		currentDialogueTxt = currentDialogueTxt + fullDialogueTxt[txtIndex]
		txtIndex += 1
		dialogueLabel.text = currentDialogueTxt
		if(txtIndex >= fullDialogueTxt.length()):
			displayingDialogue = false
			if(closable):
				dialogueEnd = true
			emit_signal("dialogueEndSignal")
	
	if Input.is_action_just_pressed('interact') and closable and dialogueEnd:
		dialogueUI._showDialogueBox(false)
		dialogueUI._showPortrait(false)
		closable = false
		dialogueEnd = false
		player._lockCharacter(false)
		currentDialogueTxt = ""
		dialogueLabel.text = currentDialogueTxt

func _displayDialogueClosable(dialogueText):
	if(displayingDialogue):
		return
		
	closable = true
	_displayDialogue(dialogueText)
			
func _displayDialogue(dialogueText):
	if(displayingDialogue):
		return
	
	currentDialogueTxt = ""
	txtIndex = 0
	displayingDialogue = true
	fullDialogueTxt = dialogueText
	print(fullDialogueTxt)
	
