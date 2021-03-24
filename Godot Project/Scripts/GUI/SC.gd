extends Panel

var path_to_main_menu ="res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn";
var path_to_game = "res://Scenes/Test Scenes/RP Test Scene.tscn"

onready var profile_image = get_node("MarginContainer/HBoxContainer/CenterContainer/TextureRect")
onready var class_label = get_node("MarginContainer/HBoxContainer/VBoxContainer/Class/Data")
onready var health_label = get_node("MarginContainer/HBoxContainer/VBoxContainer/Health/Data")
onready var multiplier_label = get_node("MarginContainer/HBoxContainer/VBoxContainer/Multiplier/Data")

onready var select_warrior = get_node("../../HBoxContainer2/CenterContainer/SelectWarrior")
onready var select_average = get_node("../../HBoxContainer2/CenterContainer3/SelectAverage")
onready var select_thief = get_node("../../HBoxContainer2/CenterContainer2/SelectThief")


func _ready():
	var class_data = load("res://Resources/images/Warrior.tres")
	update_class_display(class_data)
	
	
func update_class_display(class_Data):
	profile_image.texture = class_Data.profile
	class_label.text = class_Data.characterType
	health_label.text = str(class_Data.health)
	multiplier_label.text = str(class_Data.multiplier)


func _on_WarriorButton_pressed():
	var class_data = load("res://Resources/images/Warrior.tres")
	update_class_display(class_data)
	select_warrior.disabled = false
	select_average.disabled = true
	select_thief.disabled = true

func _on_AverageButton_pressed():
	var class_data = load("res://Resources/images/Average.tres")
	update_class_display(class_data)
	select_warrior.disabled = true
	select_average.disabled = false
	select_thief.disabled = true

func _on_ThiefButton_pressed():
	var class_data = load("res://Resources/images/Thief.tres")
	update_class_display(class_data)
	select_thief.disabled = false
	select_average.disabled = true
	select_warrior.disabled = true


# Go to the game scene based on the selection
func _on_SelectWarrior_pressed():
	GlobalVariables.charSelected = 0
	get_tree().change_scene(path_to_game)
	print("Warriror Selected")
	print("World ",GlobalVariables.world_num)
	
	
func _on_SelectAverage_pressed():
	GlobalVariables.charSelected = 1
	get_tree().change_scene(path_to_game)
	print("Average Selected")
	print("World ",GlobalVariables.world_num)
	

func _on_SelectThief_pressed():
	GlobalVariables.charSelected = 2
	get_tree().change_scene(path_to_game)
	print("Theif Selected")
	print("World ",GlobalVariables.world_num)
