extends Node

const FIRESTORE_URL := "https://ssadmazerunner-default-rtdb.firebaseio.com/"

var id_token
var id
var username
var user_id
var http

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	pass

func save_world_score(world: int, score: int, http: HTTPRequest) ->void:
	user_id = FirebaseAuth._get_user_id()
	id_token = FirebaseAuth._get_current_token_id()
	var fields := {
		"student-id": user_id,
		"score": score
	}
	var body := to_json(fields)
	var path = "leaderboard/World "+str(world)+ ".json"
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_POST, body)

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	id_token = FirebaseAuth._get_current_token_id()
	print("id_token")
	print(id_token)
	var body := to_json(fields)
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_POST, body)

func get_world_leaderboard_data(world: int, http: HTTPRequest) -> void:
	id_token = FirebaseAuth._get_current_token_id()
	var path = "leaderboard/World "+str(world)+ ".json"
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	print(http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_GET))

func get_document(path: String, http: HTTPRequest):
	id_token = FirebaseAuth._get_current_token_id()
	print("id_token")
	print(id_token)
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	print(http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_GET))
	#remove the print later

func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void: #NOT DONE YET
	var document := { "fields": fields }
	var body := to_json(document)
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_PATCH, body)


func delete_document(path: String, http: HTTPRequest) -> void: #NOT DONE YET
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_DELETE)
