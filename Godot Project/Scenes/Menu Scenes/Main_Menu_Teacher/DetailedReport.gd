extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var http2 : HTTPRequest = $HTTPRequest2
# Declare member variables here. 
var path_to_main_menu_teacher =  "res://Scenes/Menu Scenes/Main_Menu_teacher/MainMenuTeacher.tscn";
var wSelected = 0
# 1 = world 1
# 2 = world 2
var handler
var handler2
var data_from_db
var data_from_db2
var studsScoreData = {}
var studsAnalyticsData = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	handler2 = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	add_child(handler2)
	
func get_leaderboard_data():
	print("getting leaderboard data...")
	if wSelected == 1:
		handler.get_world_leaderboard_data(1, self.http) #for now assume world		
	elif wSelected == 2:
		handler.get_world_leaderboard_data(2, self.http) #for now assume world


func get_studentanalytics_data():
	print("getting student analytics data....")
	if wSelected == 1:
		handler2.get_document("student-analytics/World 1.json",self.http2)
	elif wSelected == 2:
		handler2.get_document("student-analytics/World 2.json",self.http2)
		
func process_db_data():
	var id = 0
	for key in data_from_db:
		var studName=null
		var score=null
		var studId=null
		var value = data_from_db[key]
		print("key: " + key + " value: " + str(value))
		score = value["score"]
		studName = value["student-name"]
		studId = value["student-id"]
		var studScoreArray = [studName,score,key]
		studsScoreData[id] = studScoreArray
		studScoreArray = []
		id += 1
		
func process_db_data2():
	var id2 = 0
	for key in data_from_db2:
		var value = data_from_db2[key]
		print("studanaly key: " + key + " value: " + str(value))
		var eC = value["easy"]["correct"]
		var eW = value["easy"]["wrong"]
		var mC = value["medium"]["correct"]
		var mW = value["medium"]["wrong"]
		var hC = value["hard"]["correct"]
		var hW = value["hard"]["wrong"]
		var studId = value["id"]
		var studAnalyticsArray = [key,eC,eW,mC,mW,hC,hW]
		studsAnalyticsData[id2] = studAnalyticsArray
		studAnalyticsArray = []
		id2 += 1



func show_detailed_report():
	for i in studsScoreData:
		var value = studsScoreData[i]
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/nameLbl").text += str(value[0]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/scoreLbl").text += str(value[1]) + "\n"
		
func show_detailed_report2():
	for j in studsAnalyticsData:
		var value = studsAnalyticsData[j]
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/easyCorrLbl").text += str(value[1]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/easyWrongLbl").text += str(value[2]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/medCorrLbl").text += str(value[3]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/medWrongLbl").text += str(value[4]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/hardCorrLbl").text += str(value[5]) + "\n"
		get_node("VBoxContainer/ScrollContainer/HBoxContainer/hardWrongLbl").text += str(value[6]) + "\n"


func _on_GR_selectW1Btn_pressed():
	get_node("ConfirmGR").visible = true
	get_node("ConfirmGR").dialog_text = "Generate Detailed Report for World 1?"
	wSelected = 1


func _on_GR_selectW2Btn_pressed():
	get_node("ConfirmGR").visible = true
	get_node("ConfirmGR").dialog_text = "Generate Detailed Report for World 2?"
	wSelected = 2

	
func _on_GR_gobackBtn_pressed():
	get_tree().change_scene(path_to_main_menu_teacher)


func _on_ConfirmationDialog_confirmed():
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/nameLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/scoreLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/easyCorrLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/easyWrongLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/medCorrLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/medWrongLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/hardCorrLbl").text = ""
	get_node("VBoxContainer/ScrollContainer/HBoxContainer/hardWrongLbl").text = ""
	studsScoreData = {}
	studsAnalyticsData = {}
	if(wSelected == 1):
		print("successw1")
		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 1"
	elif(wSelected == 2):
		print("successw2")
		get_node("VBoxContainer/wSelectedLbl").text = "World Selected: \n World 2"
	get_leaderboard_data()
	get_studentanalytics_data()	


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
			show_detailed_report()
			return
	print("some other error")



func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	print("http request 2 completed")
	var result_body2 := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			print("error 404")
			return
		200:
			print("success 200")
			print(result_body2)
			data_from_db2 = result_body2
			process_db_data2()
			show_detailed_report2()
			return
	print("some other error")
