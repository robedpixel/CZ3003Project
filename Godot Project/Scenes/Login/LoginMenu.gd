extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var username = ""
var password = ""

const API_KEY = "AIzaSyD3FJ3I9YwIgde-M5aZoiQlZsTOd1GpJzk"
const REGISTER_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" % API_KEY
const LOGIN_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" % API_KEY

func _get_token_id_from_result(result: Array) -> String:
	var result_body:= JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return result_body.idToken

func login(email: String, password: String, http: HTTPRequest) -> void:
	var body:= {
		"email": email,
		"password": password,
		"returnSecureToken": true
		}
		http.request(LOGIN_URL, [], false, HTTPCLIENT.METHOD_POST, to_json(body))
		var result:= yield(http, "request_completed") as Array
		if result[1] ==200:
			current_token = _get_token_id_from_result(result)
	

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
