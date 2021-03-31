extends Control

#onready var http : HTTPRequest = $HTTPRequest

var username = ""
var password = ""

func _ready():
	var http = HTTPRequest.new()
	add_child(http)
	var url ="https://api.telegram.org/bot1704019245:AAG7Qo_Pq7l4qr6gHPLY2DAJ-M08FQd_0Zk/sendMessage?chat_id=@SSAD_runner_check&text=Game%20has%20been%20run"
	http.request(url, [], true, HTTPClient.METHOD_POST, "")
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
