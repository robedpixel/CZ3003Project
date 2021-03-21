extends Node


onready var dialogueBox = $DialogueBox

onready var portraitBG = $Portrait

onready var playerPortrait = $Portrait/ViewportContainer/Viewport/PlayerPortrait
onready var enemyPortrait = $Portrait/ViewportContainer/Viewport/EnemyPortrait

var easyMobPortrait = preload("res://Resources/images/Monster/Drawing/monster_easy.png")
var medMobPortrait = preload("res://Resources/images/Monster/Drawing/monster_med.png")
var hardMobPortrait = preload("res://Resources/images/Monster/Drawing/monster_hard.png")
var bossMobPortrait = preload("res://Resources/images/Monster/Drawing/monster_boss.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	_showDialogueBox(false)
	_showPortrait(false)

func _showDialogueBox(show):
	dialogueBox.visible = show
	
func _showPortrait(show):
	portraitBG.visible = show
	if(!show):
		playerPortrait.visible = false
		enemyPortrait.visible = false
	
func _showPlayerPortrait(portrait):
	playerPortrait.visible = true
	playerPortrait.set_texture(portrait)

func _setMonsterPortrait(monster):
	enemyPortrait.visible = true
	
	match monster.difficulty:
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY:
			enemyPortrait.set_texture(easyMobPortrait)
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED:
			enemyPortrait.set_texture(medMobPortrait)
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD:
			enemyPortrait.set_texture(hardMobPortrait)
		GlobalVariables.RoomEnum.BOSS_ROOM:
			enemyPortrait.set_texture(bossMobPortrait)
		_:
			pass
