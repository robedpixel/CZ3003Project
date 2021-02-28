extends Control

#onready var http : HTTPRequest = $HTTPRequest

var username = ""
var password = ""

func _ready():
	pass

func _on_Button_pressed():
	username = $"VBoxContainer/UsernameContainer/UsernameInputBox".get_text()
	password = $"VBoxContainer/PasswordContainer/PasswordInputBox".get_text()
	var success = FirebaseAuth.login(username,password)
	if success:
		get_tree().change_scene("res://Scenes/Database Test/Database Test.tscn")
	else:
		print("cannot log in")
