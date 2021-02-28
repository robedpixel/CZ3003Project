extends Node

const FIRESTORE_URL := "https://ssadmazerunner-default-rtdb.firebaseio.com/"

var id_token
var id
var username
var http

func _ready():
	pass

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	id_token = FirebaseAuth._get_current_token_id()
	print("id_token")
	print(id_token)
	var document := { "fields": fields }
	var body := to_json(document)
	var url = FIRESTORE_URL + path + "?auth=%s" % id_token
	http.request(url, FirebaseAuth._get_request_headers(), false, HTTPClient.METHOD_POST, body)


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
