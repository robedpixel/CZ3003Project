extends Control

#onready var http : HTTPRequest = $HTTPRequest

var username = ""
var password = ""

func _ready():
	pass

func _on_Button_pressed():
	username = $"VBoxContainer/UsernameContainer/UsernameInputBox".get_text()
	password = $"VBoxContainer/PasswordContainer/PasswordInputBox".get_text()
	var success = yield(FirebaseAuth.login(username,password),"completed")
	if success:
		#Scene for testing database accesses
		#get_tree().change_scene("res://Scenes/Database Test/Database Test.tscn")
		#get_tree().change_scene("res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn")
		get_tree().change_scene("res://Scenes/Menu Scenes/Leaderboard/Leaderboard.tscn")
	else:
		$"VBoxContainer/LoginStatusLabel".set_text("Incorrect username and/or password")
		print("cannot log in")
