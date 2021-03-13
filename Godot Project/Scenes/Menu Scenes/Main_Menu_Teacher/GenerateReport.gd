extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_to_main_menu_teacher =  "res://Scenes/Menu Scenes/Main_Menu_teacher/MainMenuTeacher.tscn";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GR_selectW1Btn_pressed():
	get_node("ConfirmGR").visible = true
	get_node("ConfirmGR").dialog_text = "Generate report for World 1?"
	


func _on_GR_selectW2Btn_pressed():
	get_node("ConfirmGR").visible = true
	get_node("ConfirmGR").dialog_text = "Generate report for World 2?"


func _on_GR_gobackBtn_pressed():
	get_tree().change_scene(path_to_main_menu_teacher)


func _on_ConfirmationDialog_confirmed():
	print("success!")

