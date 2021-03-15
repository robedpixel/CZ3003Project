extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_to_main_menu_teacher =  "res://Scenes/Menu Scenes/Main_Menu_teacher/MainMenuTeacher.tscn";
var wSelected = 0;
# 1 = world 1
# 2 = world 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GR_selectW1Btn_pressed():
	get_node("ConfirmGR").visible = true
	get_node("ConfirmGR").dialog_text = "Generate Detailed Report for World 1?"
	wSelected = 1


func _on_GR_selectW2Btn_pressed():
	get_node("ConfirmGR").visible = true
	get_node("ConfirmGR").dialog_text = "Generate Detailed Report for World 2?"
	wSelected = 2

	
func _on_GR_gobackBtn_pressed():
	get_tree().change_scene(path_to_main_menu_teacher)


func _on_ConfirmationDialog_confirmed():
	if(wSelected == 1):
		print("successw1")
		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 1"
		get_node("VBoxContainer/detReportLbl").text = "World 1 Detailed Report \n Student Name: Felix Score: 500\n Student Name : Shah Score : 500"
	elif(wSelected == 2):
		print("successw2")
		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 2"
		get_node("VBoxContainer/detReportLbl").text = "World 2 Detailed Report \n Student Name: YY Score: 600\n Student Name : Samuel Score : 600"	


