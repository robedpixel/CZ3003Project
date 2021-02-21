extends Control

# a main code for the buttons in the scene pages to get back to the main menu
func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Main_Menu/Main Menu.tscn")
