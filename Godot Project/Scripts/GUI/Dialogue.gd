extends Node



onready var dialogueLabel = $Label

var displayingDialogue : bool = false
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
			emit_signal("dialogueEndSignal")
			
			
func _displayDialogue(dialogueText):
	
	currentDialogueTxt = ""
	txtIndex = 0
	displayingDialogue = true
	fullDialogueTxt = dialogueText
	
