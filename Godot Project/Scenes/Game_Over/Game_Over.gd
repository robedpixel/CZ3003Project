extends Node

var handler
var score = 123

func _ready():
	handler = load("res://Scripts/auth/firebase_db.gd").new()
	add_child(handler)
	get_node("CenterContainer/VBoxContainer/HBoxContainer/ScoreLabel").text += str(score)
	#handler.save_world_score(world, score) #not sure how to get world and score yet



func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu Scenes/Leaderboard/Leaderboard.tscn")
