extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var monsterSprite = $MonsterSprite

export var difficulty = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "monster")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _disableAndHide():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	monsterSprite.visible = false
	
func _enable():
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	monsterSprite.visible = true
