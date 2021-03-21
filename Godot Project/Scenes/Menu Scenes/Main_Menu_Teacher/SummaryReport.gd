extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var alert_dialog = get_node("WindowDialog")
onready var alert_label = get_node("WindowDialog/VBoxContainer/DialogLabel")

var handler
var data_from_db
var path_to_main_menu_teacher =  "res://Scenes/Menu Scenes/Main_Menu_teacher/MainMenuTeacher.tscn";
var wSelected = 0;# 1 = world 1, 2 = world 2

var studsScoreData = {
}

func _ready():
	
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	
func get_leaderboard_data():
	print("getting leaderboard data...")
	if wSelected == 1:
		handler.get_world_leaderboard_data(1, self.http) #for now assume world
	elif wSelected == 2:
		handler.get_world_leaderboard_data(2, self.http) #for now assume world
	
func process_db_data():
	var id = 0;
	for key in data_from_db:
		var studName=null
		var score=null
		var value = data_from_db[key]
		print("key: " + key + " value: " + str(value))
		score = value["score"]
		studName = value["student-name"]
		var studScoreArray = [studName,score]
		studsScoreData[id] = studScoreArray
		id += 1

func show_summary_report():
	var totalScore = 0
	for i in studsScoreData:
		var value = studsScoreData[i]
		totalScore += value[1]
		get_node("VBoxContainer/ScrollContainer/HBoxContainer3/nameLbl").text += str(value[0]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer3/scoreLbl").text += str(value[1]) + "\n"
	var avgScore = totalScore/studsScoreData.size()
	get_node("VBoxContainer/avgScoreLbl").text = "Average score: " + str(avgScore)

func _on_GR_selectW1Btn_pressed():
#	get_node("ConfirmGR").visible = true
#	get_node("ConfirmGR").dialog_text = "Generate Summary report for World 1?"
	alert_dialog.visible = true
	alert_label.text = "Generate Summary report for World 1?"
	wSelected = 1


func _on_GR_selectW2Btn_pressed():
#	get_node("ConfirmGR").visible = true
#	get_node("ConfirmGR").dialog_text = "Generate Summary report for World 2?"
	alert_dialog.visible = true
	alert_label.text = "Generate Summary report for World 1?"
	wSelected = 2

	
func _on_GR_gobackBtn_pressed():
	get_tree().change_scene(path_to_main_menu_teacher)


#func _on_ConfirmationDialog_confirmed():
#	get_node("VBoxContainer/ScrollContainer/HBoxContainer3/nameLbl").text = ""
#	get_node("VBoxContainer/ScrollContainer/HBoxContainer3/scoreLbl").text = ""
#	studsScoreData = {}
#	if(wSelected == 1):
#		print("successw1")
#		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 1"
#	elif(wSelected == 2):
#		print("successw2")
#		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 2"
#	get_leaderboard_data()
		

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
			show_summary_report()
			#show_sorted_leaderboard()
			return
	print("some other error")


func _on_CancelButton_pressed():
	alert_dialog.visible =false


func _on_ConfirmButton_pressed():
	get_node("VBoxContainer/ScrollContainer/HBoxContainer3/nameLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer3/scoreLbl").text = ""
	studsScoreData = {}
	if(wSelected == 1):
		print("successw1")
		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 1"
	elif(wSelected == 2):
		print("successw2")
		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 2"
	get_leaderboard_data()
	alert_dialog.visible =false
