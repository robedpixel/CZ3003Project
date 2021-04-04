extends Node

class_name QuestionManager
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# stored_questions is a list
var question_array : Array = Array()
var num_questions :int = 0
var unasked_questions: int = 0
var asked_questions: Array = Array()
var rng = RandomNumberGenerator.new()
var temp_int : int

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func _read_json_from_source(path : String)->Dictionary:
	var file = File.new()
	file.open(path, file.READ)
	var json = file.get_as_text()
	file.close()
	var json_result = JSON.parse(json).result
	return json_result

func _read_questions(questions_json: Dictionary)->void:
	var counter : int = 0
	for key in questions_json:
		counter = counter + 1
	self.num_questions = counter
	self.question_array.resize(counter)
	counter = 0
	for question in questions_json:
		self.question_array[counter] = CombatQuestion.new()
		self.question_array[counter].question = questions_json[question]["question"]
		self.question_array[counter].answer_a = questions_json[question]["answer_a"]
		self.question_array[counter].answer_b = questions_json[question]["answer_b"]
		self.question_array[counter].answer_c = questions_json[question]["answer_c"]
		self.question_array[counter].answer_d = questions_json[question]["answer_d"]
		self.question_array[counter].correct_answer = questions_json[question]["cor_answer"]
		counter = counter + 1
		
func _add_questions(questions_json: Dictionary)->void:
	var counter : int = num_questions
	for key in questions_json:
		counter = counter + 1
	question_array.resize(counter)
	counter = num_questions
	for question in questions_json:
		question_array[counter] = CombatQuestion.new()
		question_array[counter].question = questions_json[question]["question"]
		question_array[counter].answer_a = questions_json[question]["answer_a"]
		question_array[counter].answer_b = questions_json[question]["answer_b"]
		question_array[counter].answer_c = questions_json[question]["answer_c"]
		question_array[counter].answer_d = questions_json[question]["answer_d"]
		question_array[counter].correct_answer = questions_json[question]["cor_answer"]
		counter = counter + 1

func read_questions_from_source(path : String):
	var json_result = _read_json_from_source(path)
	print(json_result)
	self._read_questions(json_result)
	
func add_questions_from_source(path : String):
	var json_result = _read_json_from_source(path)
	self._add_questions(json_result)

#To be called once before any subsequent calls to ask_question
func prepare_questions():
	self.asked_questions.resize(self.num_questions)
	for i in range(0, self.asked_questions.size()):
		self.asked_questions[i] = false
	unasked_questions = num_questions

func ask_question()->CombatQuestion:
	self.temp_int = rng.randi_range(0,unasked_questions-1)
	for i in range(0, self.question_array.size()):
		if asked_questions[i]==false:
			if self.temp_int != 0:
				self.temp_int = self.temp_int - 1
			else:
				unasked_questions = unasked_questions - 1
				asked_questions[i] = true
				
				#reset asked questions if all questions have been asked
				if unasked_questions == 0:
					unasked_questions = num_questions
					for j in range(0, asked_questions.size()):
						asked_questions[j] = false
						
				return self.question_array[i]
	return null

func clear_questions_array():
	for n in question_array:
		if n.is_inside_tree():
			n.queue_free()
			n = null
		else:
			n.free()
			n = null
	question_array.clear()
	self.num_questions = 0

#Returns Array of combat questions saved in the object
func get_questions_array() ->Array:
	return self.question_array
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
