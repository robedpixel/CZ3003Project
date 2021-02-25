extends Control


var scene_path
var x =0

# for connecting the buttons to the respective buttons
func _ready():
	$VBoxContainer/CenterRow/Buttons/SelectWorldButton.grab_focus() #for keyboard movements in the main menu
	for button in $VBoxContainer/CenterRow/Buttons.get_children():
		button.connect("pressed",self,"on_pressed", [button.scene_to_load])


# the parent scene is named as scenecontroller -> can be seen at the project folder itself
# the children scene are at its repspective files e.g res://Select_World/SelectWorld.tscn 

# on each button press, the respective page will open up
func on_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
	
