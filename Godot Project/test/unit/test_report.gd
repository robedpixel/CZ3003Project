extends "res://addons/gut/test.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var loginscene = load("res://Scenes/Login/LoginMenu.tscn")
var reportscene = load("res://Scenes/Menu Scenes/Main_Menu_Teacher/SummaryReport.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func test_open_report_scene():
	var testscene_1 = loginscene.instance()
	add_child(testscene_1)
	#modify scene variables
	testscene_1.get_node("UsernameContainer").get_node("UsernameInputBox").set_text("jabirsha001@e.ntu.edu.sg")
	testscene_1.get_node("PasswordContainer").get_node("PasswordInputBox").set_text("testpassword")
	
	yield(testscene_1._on_Button_pressed(),"completed")
	var testscene_2 = reportscene.instance()
	add_child(testscene_2)
	
	var scene = has_node("Generate Report")
	assert_eq(scene,true,"Summary report page should load after successful teacher login")
	
	remove_child(testscene_2)
	testscene_2.queue_free()
	
	remove_child(testscene_1)
	testscene_1.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
