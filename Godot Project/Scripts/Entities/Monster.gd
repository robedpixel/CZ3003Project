extends Node2D


onready var monsterSprite = $MonsterSprite
onready var monsterHealth = $Health

onready var cmbtManager = get_node("/root/Main/CombatManager")

var difficulty

onready var tween = $Tween
onready var shakeTween = $ShakeTween

var tween_values = [-20.0, 20.0]
var shakeMax = 8
var shakeCount = 0

signal tween_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "monster")
	connect("tween_completed", self, "_on_tween_completed")
	

func _interact(player):
	cmbtManager._enterCombat(self)
	return ""

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

func _deathAnim():
	monsterSprite.visible = true
	_setShake(8)
	
	tween.interpolate_property(monsterSprite, "modulate", Color(1, 1, 1, 1), Color(1, 0.7, 0.7, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	start_shake_tween()
	
	yield(tween, "tween_completed")
	
	tween.interpolate_property(monsterSprite, "modulate", Color(1, 0.7, 0.7, 1), Color(1, 0.2, 0.2, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_completed")
	
	tween.interpolate_property(monsterSprite, "modulate", Color(1, 0.2, 0.2, 1), Color(1, 0.2, 0.2, 0.0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, "position:y", get_position().y, get_position().y + 100, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	cmbtManager._monsterDeathAnimEnd()
	
func _setShake(shakeMax):
	shakeCount = 0
	self.shakeMax = shakeMax

func start_shake_tween():
	shakeTween.interpolate_property(self, "position:x", 640 + tween_values[0], 640 + tween_values[1], 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	shakeTween.start()	

func _on_ShakeTween_tween_completed(object, key):
	if(shakeCount > shakeMax):
		return
		
	tween_values.invert()
	shakeCount += 1
	
	start_shake_tween()
