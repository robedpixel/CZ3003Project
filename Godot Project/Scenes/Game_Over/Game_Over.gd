extends Node

var handler
var score = 0

func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	pass

func _saveScore(coins):
	# Get analytics variable
	var topicSelected = GlobalVariables.topic_selected
	var charSelected = GlobalVariables.charSelected
	GlobalVariables.score = coins
	var score = coins
	
	get_node("CenterContainer/VBoxContainer/HBoxContainer/ScoreLabel").text += str(score)
	
#	print(AnalyticVariables["easy"]["correct"])
#	print(AnalyticVariables["hard"]["correct"])
	
	yield(handler.save_world_score(topicSelected+1, score), "completed")
	print("save_world_score done")
	yield(handler.save_analytics(topicSelected+1),"completed")
	print("save_analytics done")

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu Scenes/Leaderboard/Leaderboard.tscn")
