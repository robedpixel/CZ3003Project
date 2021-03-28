extends Control


# Declare member variables here.
var path_to_generate_summReport =  "res://Scenes/Menu Scenes/Main_Menu_Teacher/SummaryReport.tscn";
var path_to_generate_detReport =  "res://Scenes/Menu Scenes/Main_Menu_Teacher/DetailedReport.tscn";
var path_to_login = "res://Scenes/Login/LoginMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	get_tree().change_scene(path_to_generate_summReport)


func _on_Button2_pressed():
	get_tree().change_scene(path_to_generate_detReport)


func _on_LogoutButton_pressed():
	get_tree().change_scene(path_to_login)
