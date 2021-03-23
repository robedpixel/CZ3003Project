extends Button

var path_to_char_select ="res://Scenes/Menu Scenes/Select_Character/CharacterSelection.tscn";
onready var alert_dialog = get_node("../../../../WindowDialog")

	

func _on_World1Button_pressed():
	get_tree().change_scene(path_to_char_select)
	GlobalVariables.world_num = 0
	GlobalVariables.topic_selected = 0
	print("Selected world ",GlobalVariables.world_num)
	print("Selected topic ",GlobalVariables.topic_selected)
	

func _on_World2Button_pressed():
	get_tree().change_scene(path_to_char_select)
	GlobalVariables.world_num= 1
	GlobalVariables.topic_selected = 1
	print("Selected world ",GlobalVariables.world_num)
	print("Selected topic ",GlobalVariables.topic_selected)


func _on_FriendMaze_pressed():
	alert_dialog.visible=true
