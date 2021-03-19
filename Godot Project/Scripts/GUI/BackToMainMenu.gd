extends Button

var path_to_main_menu ="res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn";
var path_to_select_world =  "res://Scenes/Menu Scenes/Select_World/SW.tscn";

func _on_MCBackButton_pressed():
	get_tree().change_scene(path_to_main_menu)

func _on_LBBackButton_pressed():
	get_tree().change_scene(path_to_main_menu)

func _on_SWBackButton_pressed():
	get_tree().change_scene(path_to_main_menu)

func _on_CSBackButton_pressed():
	get_tree().change_scene(path_to_select_world)
	GlobalVariables.world_num = null
	print("Selected world ",GlobalVariables.world_num)






