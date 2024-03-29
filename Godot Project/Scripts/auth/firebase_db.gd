extends Node

const FIRESTORE_URL := "https://ssadmazerunner-default-rtdb.firebaseio.com/"

var id_token
var id
var username
var user_id
var http
var student_name

func _ready():
	print("firebase db ready")
	http = HTTPRequest.new()
	add_child(http)
	pass

func save_world_score(world: int, score: int) ->void:
	user_id = FirebaseAuth._get_user_id()
	id_token = FirebaseAuth._get_current_token_id()
	student_name = yield(get_student_name(), "completed")
	print(student_name)
	var url = FIRESTORE_URL + "student-analytics/World "+str(world)+ ".json" + "?auth=%s" % id_token
	
	var fields := {
		"id": user_id,
		"score": score,
		"student-name": student_name,
		"easy": { 
			"correct": AnalyticVariables.easy.correct,
			"wrong": AnalyticVariables.easy.wrong
		}, 
		"medium": { 
			"correct": AnalyticVariables.medium.correct,
			"wrong": AnalyticVariables.medium.wrong
		}, 
		"hard": { 
			"correct": AnalyticVariables.hard.correct,
			"wrong": AnalyticVariables.hard.wrong
		}
	}
	var body := to_json(fields)
	print(http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_POST, body))
	yield(http, "request_completed")

func save_analytics(world: int) ->void:
	id_token = FirebaseAuth._get_current_token_id()
	var path = "analytics/World "+str(world)+ ".json"
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_GET)
	var result:= yield(http, "request_completed") as Array
	if result[1] ==200:
		var existing_data = JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		print("existing data:")
		print(existing_data)
		var fields := {
			"easy": { 
				"correct": existing_data.easy.correct + AnalyticVariables.easy.correct,
				"wrong": existing_data.easy.wrong + AnalyticVariables.easy.wrong
			}, 
			"medium": { 
				"correct": existing_data.medium.correct + AnalyticVariables.medium.correct,
				"wrong": existing_data.medium.wrong + AnalyticVariables.medium.wrong
			}, 
			"hard": { 
				"correct": existing_data.hard.correct + AnalyticVariables.hard.correct,
				"wrong": existing_data.hard.wrong + AnalyticVariables.hard.wrong
			}
		}
		var body := to_json(fields)
		print("updating analytics...")
		http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_PATCH, body)

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	id_token = FirebaseAuth._get_current_token_id()
	print("id_token")
	print(id_token)
	var body := to_json(fields)
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_POST, body)

func get_world_leaderboard_data(world: int, http: HTTPRequest) -> void:
	id_token = FirebaseAuth._get_current_token_id()
	var path = "student-analytics/World "+str(world)+ ".json"
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	print(http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_GET))

func get_document(path: String, http: HTTPRequest):
	id_token = FirebaseAuth._get_current_token_id()
	print("id_token")
	print(id_token)
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_GET)

func get_student_name():
	id_token = FirebaseAuth._get_current_token_id()
	user_id = FirebaseAuth._get_user_id()
	var path = "student/" + user_id + ".json"
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_GET)
	var result:= yield(http, "request_completed") as Array
	if result[1] ==200:
		var data = JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		print(data)
		return(data["student-name"])
