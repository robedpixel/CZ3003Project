extends Node


onready var monsterSprite = $MonsterSprite
onready var monsterHealth = $Health

onready var cmbtManager = get_node("/root/Main/CombatManager")

var difficulty

onready var tween = $Tween

signal tween_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "monster")
	connect("tween_completed", self, "_on_tween_completed")
	

func _interact(player):
	cmbtManager._enterCombat(self)

func _disableAndHide():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	monsterSprite.visible = false
	monsterSprite.playing = false
	
func _enable():
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	monsterSprite.playing = true
	monsterSprite.visible = true
	

func _setSpriteFrames(spriteFrames):
	$MonsterSprite._setSpriteFrames(spriteFrames)

func _hideSprite():
	monsterSprite.visible = false

func _setDifficulty(difficulty):
	self.difficulty = difficulty
	
func _monsterFadeInAnim():
	monsterSprite.visible = true
	$Tween.interpolate_property(monsterSprite, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(self, "position:y", 360, 200, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(tween, "tween_completed")
	

