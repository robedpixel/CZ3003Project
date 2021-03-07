extends Area2D


onready var parent = get_parent()
onready var collisionShape = $CollisionShape2D

# Interactable Area should be a child of the interactable object
# Parent script should implement _interact() function
# Player should exist in scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.|

func _on_Interactable_Area_body_entered(body):
	if(body.name == "Player"):
		print("Enter " + self.name)
		body._AddInteractable(parent)

func _on_Interactable_Area_body_exited(body):
	if(body.name == "Player"):
		print("Enter " + self.name)
		body._RemoveInteractable(parent)

func _on_Area2D_body_entered(body):
	if(body.name == "Player"):
		print("Enter " + self.name)
		body._AddInteractable(parent)
		
func _on_Area2D_body_exited(body):
	if(body.name == "Player"):
		print("Exit " + self.name)
		body._RemoveInteractable(parent)
		
func _enable():
	set_collision_mask_bit(0, true)
	
func _disable():
	set_collision_mask_bit(0, false)
