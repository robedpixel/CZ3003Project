extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var username = ""
var password = ""

const API_KEY = ""
const REGISTER_URL = ""
const LOGIN_URL = ""

func _get_token_id_from_result(result: Array) -> String:
	var result_body:= JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return result_body.idToken



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	username = $"VBoxContainer/UsernameContainer/UsernameInputBox".get_text()
	password = $"VBoxContainer/PasswordContainer/PasswordInputBox".get_text()
	
	print(username)
	print(password)
	pass # Replace with function body.
