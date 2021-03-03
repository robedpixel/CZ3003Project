extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var parent = get_parent()
onready var collisionShape = $CollisionShape2D

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



func _on_Area2D_body_entered(body):
	print("Enter")
	if(body.name == "Player"):
		body._AddInteractable(parent.name)
		


func _on_Area2D_body_exited(body):
	print("Exit")
	if(body.name == "Player"):
		body._RemoveInteractable(parent.name)
		
func _enable():
	set_collision_mask_bit(0, true)
	
func _disable():
	set_collision_mask_bit(0, false)
