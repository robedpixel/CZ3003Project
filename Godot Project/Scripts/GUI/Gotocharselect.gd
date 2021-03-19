extends Button

var path_to_char_select ="res://Scenes/Menu Scenes/Select_Character/CharacterSelection.tscn";



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_World1Button_pressed():
	get_tree().change_scene(path_to_char_select)
	GlobalVariables.world_num = 1
	print("Selected world ",GlobalVariables.world_num)
	


func _on_World2Button_pressed():
	get_tree().change_scene(path_to_char_select)
	GlobalVariables.world_num= 2
	print("Selected world ",GlobalVariables.world_num)


func _on_FriendMaze_pressed():
	get_tree().change_scene(path_to_char_select)
	GlobalVariables.world_num= 3
	print("Selected world ",GlobalVariables.world_num)
