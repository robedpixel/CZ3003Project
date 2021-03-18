extends Control
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var questions
var combatquestion : CombatQuestion
var bookhelper
# Called when the node enters the scene tree for the first time.
func _ready():
	#questions = load("res://Scripts/Maze/QuestionManager.gd").new()
	#add_child(questions)
	#questions.read_questions_from_source("res://Resources/Questions/Requirement_Analysis.json")
	#questions.prepare_questions()
	bookhelper = load("res://Scripts/BookHelper.gd").new()
	add_child(bookhelper)
	bookhelper.read_images_from_folder("res://Resources/images/")
	pass # Replace with function body.

func _on_Testbutton_pressed():
	var image = bookhelper.get_next_image()
	var tex = ImageTexture.new()
	tex.create_from_image(image)
	$"TextureRect".texture = tex
	#for i in range(0,6):
	#	combatquestion = questions.ask_question()
	#	print(combatquestion.question)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
