extends Node


onready var dialogueUI = get_node("/root/Main/DialogueCanvas/DialogueUI")
onready var dialogue = get_node("/root/Main/DialogueCanvas/DialogueUI/DialogueBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _dialoguePlayer(portrait, dialogueText, closable):
	dialogueUI._showPlayerPortrait(portrait)
	_dialogueNoPortraitPic(dialogueText, closable)
	
func _dialogueMonster(monster, dialogueText):
	dialogueUI._setMonsterPortrait(monster)
	_dialogueNoPortraitPic(dialogueText, false)

func _dialogueNoPortraitPic(dialogueText, closable : bool):
	_show(true)
	
	if(closable):
		dialogue._displayDialogueClosable(dialogueText)
	else:
		dialogue._displayDialogue(dialogueText)
		
	$DialogueAudio.play()
	
func _show(show):
	dialogueUI._showDialogueBox(show)
	dialogueUI._showPortrait(show)
