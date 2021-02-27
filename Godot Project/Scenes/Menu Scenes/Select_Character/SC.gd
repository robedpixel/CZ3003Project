extends Panel

var path_to_main_menu ="res://Scenes/Menu Scenes/Main_Menu/Main Menu.tscn";

onready var profile_image = get_node("MarginContainer/HBoxContainer/CenterContainer/TextureRect")
onready var class_label = get_node("MarginContainer/HBoxContainer/VBoxContainer/Class/Data")
onready var health_label = get_node("MarginContainer/HBoxContainer/VBoxContainer/Health/Data")
onready var multiplier_label = get_node("MarginContainer/HBoxContainer/VBoxContainer/Multiplier/Data")

onready var select_warrior = get_node("../../HBoxContainer2/CenterContainer/SelectWarrior")
onready var select_thief = get_node("../../HBoxContainer2/CenterContainer2/SelectThief")


func _ready():
	var class_data = load("res://Scenes/Menu Scenes/Select_Character/Warrior.tres")
	update_class_display(class_data)
	
func update_class_display(class_Data):
	profile_image.texture = class_Data.profile
	class_label.text = class_Data.characterType
	health_label.text = str(class_Data.health)
	multiplier_label.text = str(class_Data.multiplier)


func _on_WarriorButton_pressed():
	var class_data = load("res://Scenes/Menu Scenes/Select_Character/Warrior.tres")
	update_class_display(class_data)
	select_warrior.disabled = false
	select_thief.disabled = true


func _on_ThiefButton_pressed():
	var class_data = load("res://Scenes/Menu Scenes/Select_Character/Thief.tres")
	update_class_display(class_data)
	select_thief.disabled = false
	select_warrior.disabled = true


# Go to the game scene based on the selection
func _on_SelectWarrior_pressed():
	get_tree().change_scene(path_to_main_menu) # Change accordingly


func _on_SelectThief_pressed():
	get_tree().change_scene(path_to_main_menu) # Change accordingly
