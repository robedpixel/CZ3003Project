extends Control
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var questions
var combatquestion : CombatQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	questions = load("res://Scripts/Maze/QuestionManager.gd").new()
	add_child(questions)
	questions.read_questions_from_source("res://Resources/Questions/Requirement_Analysis.json")
	questions.prepare_questions()
	pass # Replace with function body.

func _on_Testbutton_pressed():
	for i in range(0,6):
		combatquestion = questions.ask_question()
		print(combatquestion.question)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
