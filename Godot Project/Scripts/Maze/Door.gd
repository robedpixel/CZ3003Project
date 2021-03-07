extends Node



onready var area2D = $Area2D

onready var maze = get_tree().get_root().get_node("Main/Maze")

export var direction = "up"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "door")
	print(maze)


func _interact(player):
	maze._moveRoom(direction)

# lets just disable sprite and have an invisible door lmao godot sucks
func _toggleDoor(show):
	if(show):
		$Sprite.visible = true
		area2D._enable()
	else:
		$Sprite.visible = false
		area2D._disable()
