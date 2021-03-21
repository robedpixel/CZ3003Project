extends Node

var handler
var score = 0

func _ready():
	pass

func _saveScore(coins):
	# Get analytics variable
	var topicSelected = GlobalVariables.topic_selected
	var charSelected = GlobalVariables.charSelected
	GlobalVariables.score = coins
	var score = coins
	
	
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	get_node("CenterContainer/VBoxContainer/HBoxContainer/ScoreLabel").text += str(score)
	#handler.save_world_score(world, score) #not sure how to get world and score yet

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu Scenes/Leaderboard/Leaderboard.tscn")
