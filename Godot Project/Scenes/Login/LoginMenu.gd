extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var username = ""
var password = ""
var http
var handler
	

# Called when the node enters the scene tree for the first time.
func _ready():
	#initialise authentication module
	handler = load("res://Scripts/auth/firebase_auth.gd").new()
	add_child(handler)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	username = $"VBoxContainer/UsernameContainer/UsernameInputBox".get_text()
	password = $"VBoxContainer/PasswordContainer/PasswordInputBox".get_text()
	var success = handler.login(username,password)
	pass # Replace with function body.
