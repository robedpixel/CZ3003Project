extends Button

var path_to_main_menu ="res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn";

func _on_SWBackButton_pressed():
	get_tree().change_scene(path_to_main_menu)
	
func _on_MCBackButton_pressed():
	get_tree().change_scene(path_to_main_menu)

func _on_LBBackButton_pressed():
	get_tree().change_scene(path_to_main_menu)
