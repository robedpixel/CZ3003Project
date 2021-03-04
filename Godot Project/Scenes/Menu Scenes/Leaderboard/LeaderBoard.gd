extends Control

onready var http : HTTPRequest = $HTTPRequest

var handler

var data_from_db
var students = {
	"John" : 100,
	"Felix" : 90,
	"Samuel" : 80,
	"Yen Yong" : 200,
	"Alex" : 70,
	"Shah" : 60,
	"Winnie" : 95,
	"Tan" : 60,
	"Lim" : 80,
	"Ng" : 65,
	"Lai" : 50,
	"Clement" : 60
}

var highest = 0
const top5 = 5
var j = 1
var maxName = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	get_leaderboard_data()
	process_db_data()
	show_sorted_leaderboard()
	

func get_leaderboard_data():
	print("getting leaderboard data...")
	handler.get_world_leaderboard_data(1, self.http) #for now assume world 1

func process_db_data():
	#need to format the db data into something like the above
	pass

func show_sorted_leaderboard():
	while (j <= 11):
		highest = 0
		for i in students:
			if (students[i] > highest):
				highest = students[i]
				maxName = i
		get_node("ScrollContainer/VBoxContainer/HBoxContainer/RankLabel").text += str(j) + "\n"
		get_node("ScrollContainer/VBoxContainer/HBoxContainer/NameLabel").text += "         " + maxName + "\n"
		get_node("ScrollContainer/VBoxContainer/HBoxContainer/ScoreLabel").text += str(highest) + "\n"
		students.erase(maxName)
		j = j + 1


func _on_ShareFBBtn_pressed():
	OS.shell_open("https://www.facebook.com/groups/4064171876949849")

func _on_ShareTwitterBtn_pressed():
	OS.shell_open("https://twitter.com/intent/tweet")

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
			return
	print("some other error")
