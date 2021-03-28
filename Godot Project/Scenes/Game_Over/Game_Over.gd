extends Node

onready var leaderboard_button = get_node("CenterContainer/VBoxContainer/Button")
onready var social_media_container = get_node("SocialMediaContainer")

var handler
var score = 0
var student_name

func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	print("Print world num : ",GlobalVariables.world_num)
	add_child(handler)
	
	if(GlobalVariables.world_num==2): 
		leaderboard_button.visible=false
		social_media_container.visible=false
	else: 
		student_name = yield(handler.get_student_name(),"completed")
		leaderboard_button.visible=true
		social_media_container.visible=true
	pass

func _saveScore(coins):
	# Get analytics variable
	var topicSelected = GlobalVariables.topic_selected
	var charSelected = GlobalVariables.charSelected
	GlobalVariables.score = coins
	var score = coins
	
	get_node("CenterContainer/VBoxContainer/HBoxContainer/ScoreLabel").text += str(score)
	
	#print(AnalyticVariables["easy"]["correct"])
	#print(AnalyticVariables["hard"]["correct"])
	
	if(topicSelected != null):
		yield(handler.save_world_score(topicSelected+1, score), "completed")
		print("save_world_score done")
		yield(handler.save_analytics(topicSelected+1),"completed")
		print("save_analytics done")

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu Scenes/Leaderboard/Leaderboard.tscn")


func _on_BacktoMM_pressed():
	get_tree().change_scene("res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn")


func _on_Telegram_pressed():
	print("start func")
	print("Tele: :",student_name)
	print(GlobalVariables.world_num)
	GlobalVariables.post_to_telegram(GlobalVariables.world_num,GlobalVariables.score,null,student_name)


func _on_Twitter_pressed():
	print("start func")
	print("Twit: :",student_name)
	print(GlobalVariables.world_num)
	GlobalVariables.post_to_twitter(GlobalVariables.world_num,GlobalVariables.score,null,student_name)


func _on_Facebook_pressed():
	GlobalVariables.post_to_facebook()
