extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var alert_dialog = get_node("WindowDialog")
onready var alert_label = get_node("WindowDialog/VBoxContainer/DialogLabel")

var handler

var data_from_db
var students = {
}

var highest = 0
const top5 = 5
var j = 1
var maxName = ""
var wSelected

# Called when the node enters the scene tree for the first time.
func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)

	
	
func get_leaderboard_data():
	print("getting leaderboard data...")
	if(wSelected == 1):
		handler.get_world_leaderboard_data(1, self.http) #for now assume world 1
	elif(wSelected == 2):
		handler.get_world_leaderboard_data(2, self.http) #for now assume world 1
		
func process_db_data():
	for key in data_from_db:
		var studName=null
		var score=null
		var value = data_from_db[key]
		print("key: " + key + " value: " + str(value))
		score = value["score"]
		studName = value["student-name"]
		if(studName in students):
			#new score > old score
			if(score > students[studName]):
				students[studName] = score
		else:
			students[studName] = score

func show_sorted_leaderboard():
	while (j <= 10):
		highest = 0
		maxName = ""
		for i in students:
			if (students[i] > highest):
				highest = students[i]
				maxName = i
		get_node("ScrollContainer/VBoxContainer/HBoxContainer/RankLabel").text += str(j) + "\n"
		get_node("ScrollContainer/VBoxContainer/HBoxContainer/NameLabel").text += "         " + maxName + "\n"
		get_node("ScrollContainer/VBoxContainer/HBoxContainer/ScoreLabel").text += str(highest) + "\n"
		students.erase(maxName)
		j = j + 1
	print("shown")



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("http request completed")
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			print("error 404")
			return
		200:
			print("success 200")
			print(result_body)
			data_from_db = result_body
			process_db_data()
			show_sorted_leaderboard()
			return
	print("some other error")
	


func _on_Button_pressed():
	alert_dialog.visible = true
	alert_label.text = "Show Leaderboard for World 1?"
	wSelected = 1

func _on_Button2_pressed():
	alert_dialog.visible = true
	alert_label.text = "Show Leaderboard for World 2?"
	wSelected = 2


func _on_cancelBtn_pressed():
	alert_dialog.visible =false


func _on_confirmBtn_pressed():
	students = {}
	j = 1
	get_node("ScrollContainer/VBoxContainer/HBoxContainer/RankLabel").text = ""
	get_node("ScrollContainer/VBoxContainer/HBoxContainer/NameLabel").text = ""
	get_node("ScrollContainer/VBoxContainer/HBoxContainer/ScoreLabel").text = ""
	if(wSelected == 1):
		get_node("wSelectedLbl").text = "World Selected: World 1"
	elif(wSelected == 2):
		get_node("wSelectedLbl").text = "World Selected: World 2"
	get_leaderboard_data()
	alert_dialog.visible =false


func _on_Telegram_pressed():
	OS.shell_open("https://t.me/ssad_class")


func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/home")


func _on_Facebook_pressed():
	OS.shell_open("https://www.facebook.com/groups/4064171876949849")
