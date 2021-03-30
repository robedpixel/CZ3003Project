extends "res://addons/gut/test.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var loginscene = load("res://Scenes/Login/LoginMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func test_empty_login():
	#create scene object
	var testscene = loginscene.instance()
	add_child(testscene)
	#modify scene variables
	testscene.get_node("UsernameContainer").get_node("UsernameInputBox").set_text("")
	testscene.get_node("PasswordContainer").get_node("PasswordInputBox").set_text("")
	
	#execute function in scene(yield not used as the yield inside function is never called)
	testscene._on_Button_pressed()
	
	#check if variable in scene matches expected value
	assert_eq(testscene.get_node("VBoxContainer").get_node("LoginStatusLabel").get_text(),"Please input a valid username","Window should display error message for username when both username and password are empty")
	#free scene because we are good bois with memory(when making test cases)
	remove_child(testscene)
	testscene.queue_free()
	
func test_empty_username():
	#create scene object
	var testscene = loginscene.instance()
	add_child(testscene)
	#modify scene variables
	testscene.get_node("UsernameContainer").get_node("UsernameInputBox").set_text("")
	testscene.get_node("PasswordContainer").get_node("PasswordInputBox").set_text("ab")
	
	#execute function in scene(yield not used as the yield inside function is never called)
	testscene._on_Button_pressed()
	
	#check if variable in scene matches expected value
	assert_eq(testscene.get_node("VBoxContainer").get_node("LoginStatusLabel").get_text(),"Please input a valid username","Window should display error message when username field is empty")
	#free scene because we are good bois with memory(when making test cases)
	remove_child(testscene)
	testscene.queue_free()
	
func test_empty_password():
	#create scene object
	var testscene = loginscene.instance()
	add_child(testscene)
	#modify scene variables
	testscene.get_node("UsernameContainer").get_node("UsernameInputBox").set_text("test")
	testscene.get_node("PasswordContainer").get_node("PasswordInputBox").set_text("")
	
	#execute function in scene(yield not used as the yield inside function is never called)
	testscene._on_Button_pressed()
	
	#check if variable in scene matches expected value
	assert_eq(testscene.get_node("VBoxContainer").get_node("LoginStatusLabel").get_text(),"Please input a valid password","Window should display error message when password field is empty")
	#free scene because we are good bois with memory(when making test cases)
	remove_child(testscene)
	testscene.queue_free()

func test_wrongemailandpassword_login():
	#create scene object
	var testscene = loginscene.instance()
	add_child(testscene)
	#modify scene variables
	testscene.get_node("UsernameContainer").get_node("UsernameInputBox").set_text("a")
	testscene.get_node("PasswordContainer").get_node("PasswordInputBox").set_text("b")
	
	#execute function in scene(yield is used as the function also uses yield inside)
	yield(testscene._on_Button_pressed(),"completed")
	
	#check if variable in scene matches expected value
	assert_eq(testscene.get_node("VBoxContainer").get_node("LoginStatusLabel").get_text(),"Incorrect username/password","Window should display error message when wrong email and password are given")
	#free scene because we are good bois with memory(when making test cases)
	remove_child(testscene)
	testscene.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
