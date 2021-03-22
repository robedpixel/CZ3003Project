extends Control

#onready var http : HTTPRequest = $HTTPRequest

var username = ""
var password = ""

func _ready():
	pass

func _on_Button_pressed():
	username = $"UsernameContainer/UsernameInputBox".get_text()
	password = $"PasswordContainer/PasswordInputBox".get_text()
	if username.empty() == true:
		$"VBoxContainer/LoginStatusLabel".set_text("Please input a valid username")
	elif password.empty() == true:
		$"VBoxContainer/LoginStatusLabel".set_text("Please input a valid password")
	else:
		var success = yield(FirebaseAuth.login(username,password),"completed")
		if success:
			#Scene for testing database accesses
			#get_tree().change_scene("res://Scenes/Database Test/Database Test.tscn")
			match FirebaseAuth._get_user_role():
				FirebaseAuth.ROLE_STUDENT:
					get_tree().change_scene("res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn")
				FirebaseAuth.ROLE_TEACHER:
					get_tree().change_scene("res://Scenes/Menu Scenes/Main_Menu_Teacher/MainMenuTeacher.tscn")
				_:
					get_tree().change_scene("res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn")
		else:
			$"VBoxContainer/LoginStatusLabel".set_text("Incorrect username/password")
			print("cannot log in")
