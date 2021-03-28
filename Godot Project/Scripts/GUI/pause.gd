extends Popup


onready var tree = get_tree()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("pause")):
		tree.paused = true
		show()


func _on_ResumeButton_pressed():
	hide()
	tree.paused = false


func _on_MainMenuButton_pressed():
	hide()
	tree.paused = false
	get_tree().change_scene("res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn")
