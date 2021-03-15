extends Node

onready var cmbtManager = get_node("/root/Main/CombatManager")

export var health : int = 0
export var maxHealth : int = 0

signal onHealthAboveZero(value)
signal onHealthBelowZero(value)

# should really implement this script with player too instead of just monster. but time

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("onHealthAboveZero", cmbtManager, "_onAlive")
	connect("onHealthBelowZero", cmbtManager, "_onDeath")

func _initHealth(initMaxHealth):
	maxHealth = initMaxHealth
	health = maxHealth
	
func _minusHealth(minusHealthAmt):
	health -= minusHealthAmt
	
	if(health <= 0):
		emit_signal("onHealthBelowZero", get_parent())
	else:
		emit_signal("onHealthAboveZero", get_parent())
