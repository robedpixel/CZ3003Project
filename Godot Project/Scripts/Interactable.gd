extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.|


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Interactable_Area_body_entered(body):
	print("Enter")
	if(body.name == "Player"):
		body._AddInteractable(parent.name)


func _on_Interactable_Area_body_exited(body):
	print("Exit")
	if(body.name == "Player"):
		body._RemoveInteractable(parent.name)
