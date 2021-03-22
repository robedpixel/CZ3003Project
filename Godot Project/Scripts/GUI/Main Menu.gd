extends Control


var path_to_select_world = "res://Scenes/Menu Scenes/Select_World/SW.tscn"
var path_to_maze_creator = "res://Scenes/Menu Scenes/Maze_Creator/MC.tscn"
var path_to_leaderboard = "res://Scenes/Menu Scenes/Leaderboard/LeaderBoard.tscn"
var path_to_login = "res://Scenes/Login/LoginMenu.tscn"
var x =0

# for connecting the buttons to the respective buttons
func _ready():
	pass


# the parent scene is named as scenecontroller -> can be seen at the project folder itself
# the children scene are at its repspective files e.g res://Select_World/SelectWorld.tscn 

# on each button press, the respective page will open up

func _on_SelectWorldButton_pressed():
	get_tree().change_scene(path_to_select_world)


func _on_MazeCreatorButton_pressed():
	get_tree().change_scene(path_to_maze_creator)


func _on_LeaderBoardButton_pressed():
	get_tree().change_scene(path_to_leaderboard)


func _on_LogoutButton_pressed():
	get_tree().change_scene(path_to_login)
