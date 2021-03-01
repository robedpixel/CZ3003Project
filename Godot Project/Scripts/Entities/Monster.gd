extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export var difficulty = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "monster")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func test():
	print("TEST")
