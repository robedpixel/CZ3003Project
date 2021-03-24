extends Node

onready var leaderboard_button = get_node("CenterContainer/VBoxContainer/Button")

var handler
var score = 0

func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	if(GlobalVariables.world_num==2): leaderboard_button.visible=false
	else: leaderboard_button.visible=true
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
