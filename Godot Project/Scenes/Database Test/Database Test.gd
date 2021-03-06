extends Control

onready var http : HTTPRequest = $HTTPRequest

var studentid = ""
var studentname = ""
var score = 0
var handler
var data = {}
	

func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)


func _on_Button_pressed():
	studentid = $"VBoxContainer/LineEdit".get_text()
	studentname = $"VBoxContainer/LineEdit2".get_text()
	score = $"VBoxContainer/LineEdit3".get_text()
	print(studentid)

	data = {
		"student-id": studentid,
		"name": studentname,
		"score": score
	}
	print(data)
	#handler.save_document("leaderboard.json", data, self.http)
	handler.save_world_score(1, 30)


func _on_Button2_pressed():
	handler.get_document("leaderboard.json", self.http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			print("error 404")
			return
		200:
			print("success 200")
			print(result_body)
			return
	print("some other error")
