extends Node

class CombatQuestion:
	var question :String
	var answer_a :String
	var answer_b :String
	var answer_c :String
	var answer_d :String

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var json_result : Dictionary
var question_array : Array = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func read_question_source(path : String)->bool:
	var file = File.new()
	file.open("res://Resources/Questions/sample_json.json", file.READ)
	var json = file.get_as_text()
	file.close()
	self.json_result = JSON.parse(json).result
	return true

func read_questions()->void:
	var counter : int = 0
	for key in self.json_result:
		counter = counter + 1
		print(key)
	question_array.resize(counter)
	counter = 0
	for question in self.json_result:
		question_array[counter] = CombatQuestion.new()
		question_array[counter].question = self.json_result[question]["question"]
		question_array[counter].answer_a = self.json_result[question]["answer_a"]
		question_array[counter].answer_b = self.json_result[question]["answer_b"]
		question_array[counter].answer_c = self.json_result[question]["answer_c"]
		question_array[counter].answer_d = self.json_result[question]["answer_d"]
		counter = counter + 1

#Returns Array of combat questions saved in the object
func get_questions_array() ->Array:
	return self.question_array
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
