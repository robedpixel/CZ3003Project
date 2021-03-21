extends Node



onready var door = $Door
onready var empty = $Empty
onready var emptyCollider = $Empty/TileMap
onready var area2D = $Area2D

onready var maze = get_tree().get_root().get_node("Main/Maze")

export var direction = "up"

var locked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "door")
	print(maze)


func _interact(player):
	if(!locked):
		maze._moveRoom(direction)
		return ""
	else:
		return "Door is locked"

func _setLocked(isLocked):
	locked = isLocked

# lets just disable sprite and have an invisible door lmao godot sucks
func _toggleDoor(show):
	if(show):
		door.visible = true
		empty.visible = false
		if(emptyCollider):
			emptyCollider.set_collision_mask_bit(0, false)
		area2D._enable()
	else:
		door.visible = false
		empty.visible = true
		if(emptyCollider):
			emptyCollider.set_collision_mask_bit(0, true)
		area2D._disable()
