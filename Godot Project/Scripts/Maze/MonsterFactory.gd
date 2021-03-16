extends Node


var monsterObj = preload("res://Scenes/Prefabs/Monster.tscn")
var bossObj = preload("res://Scenes/Prefabs/Boss.tscn")

var easyFrames = preload("res://Resources/images/Monster_easy.tres")
var medFrames = preload("res://Resources/images/Monster_med.tres")
var hardFrames = preload("res://Resources/images/Monster_hard.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _createMonster(difficulty):
	var monster = monsterObj.instance()
	
	monster._setSpriteFrames(_getSpriteSheet(difficulty))
	
	return monster
	
# actually we could use monster.tscn as base, set scale and change health script health to 4
func _createBoss():
	var monster = bossObj.instance()
	
	return monster

func _getSpriteSheet(difficulty):
	match difficulty:
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY:
			return easyFrames
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED:
			return medFrames
		GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD:
			return hardFrames
		_:
			return null
			
