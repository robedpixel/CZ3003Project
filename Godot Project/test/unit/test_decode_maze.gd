extends "res://addons/gut/test.gd"
var sw_scene = load("res://Scenes/Menu Scenes/Select_World/SW.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func test_decode_empty():
	var testscene = sw_scene.instance()
	add_child(testscene)
	
	testscene.get_node("MarginContainer/WorldContainer/FriendMaze_Container/FriendMaze")._on_FriendMaze_pressed()
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/PopupLabel").get_text(),"Nothing was entered. Please enter the code".to_upper(),"Window should display error message when code field is empty")

	remove_child(testscene)
	testscene.queue_free()

func test_decode_incorrect_code():
	var testscene = sw_scene.instance()
	add_child(testscene)
	
	testscene.get_node("MarginContainer/WorldContainer/FriendMaze_Container/FriendMaze")._on_FriendMaze_pressed()
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("asds")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/PopupLabel").get_text(),"Incorrect Code. Please try again.".to_upper(),"Window should display error message when code incorrect and does not have (-)")
	
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("asds")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/PopupLabel").get_text(),"Incorrect Code. Please try again.".to_upper(),"Window should display error message when code is incorrect and does not have 1x (-)")
	
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("asds-as-as-a")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/PopupLabel").get_text(),"Incorrect Code. Please try again.".to_upper(),"Window should display error message when code is incorrect and have more than 3x (-)")
	
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("GPWfb2-D0Jo-BW")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/PopupLabel").get_text(),"Incorrect Code. Please try again.".to_upper(),"Window should display error message when code is incorrect")
	
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("GPWfb2-D0Jo-B,*?")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/PopupLabel").get_text(),"Incorrect Code. Please try again.".to_upper(),"Window should display error message when code contains char not in decoding")
	
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("GPWfb2-D0Jo-BWWWWWWWWWWWWWWWW")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/UserCode").get_text(),"".to_upper(),"Window should display error message when code is too long")

	
	remove_child(testscene)
	testscene.queue_free()


func test_decode_code_too_long():
	var testscene = sw_scene.instance()
	add_child(testscene)
	
	testscene.get_node("MarginContainer/WorldContainer/FriendMaze_Container/FriendMaze")._on_FriendMaze_pressed()
	
	testscene.get_node("WindowDialog/VBoxContainer/UserCode").set_text("GPWfb2-D0Jo-BWWWWWWWWWWWWWWWW")
	testscene.get_node("WindowDialog/VBoxContainer/HBoxContainer/ConfirmButton").decode_user_code()
	assert_eq(testscene.get_node("WindowDialog/VBoxContainer/UserCode").get_text(),"".to_upper(),"Window should display error message when code is too long")
	
	remove_child(testscene)
	testscene.queue_free()
