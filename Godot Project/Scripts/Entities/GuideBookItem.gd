extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _interact(player):
	get_node("/root/Main/Player")._lockCharacter(true)
	get_node("/root/Main/MainCanvas/GuideBook")._open()
	return ""
