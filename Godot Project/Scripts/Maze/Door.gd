extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "door")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# lets just disable sprite and have an invisible door lmao godot sucks
func _toggleDoor(show):
	if(show):
		$Sprite.visible = true
	else:
		$Sprite.visible = false
