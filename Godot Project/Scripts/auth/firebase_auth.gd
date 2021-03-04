extends Node

var username = ""
var password = ""
var http

const API_KEY := "AIzaSyD3FJ3I9YwIgde-M5aZoiQlZsTOd1GpJzk"
const REGISTER_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % API_KEY
const LOGIN_URL := "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % API_KEY
const TOKEN_URL := "https://securetoken.googleapis.com/v1/token?key=%s" % API_KEY
const FIRESTORE_URL := "https://ssadmazerunner-default-rtdb.firebaseio.com/"

var user_info := {}

func _ready():
	http = HTTPRequest.new()
	add_child(http)


func _get_user_id() ->String:
	return user_info.id

func _get_current_token_id() -> String:
	#check if current token is expired
	#if no, return current token
	#if yes, refresh token, update token and return new token
	
	#but for now, i will just return the current token
	#because firebase does not natively support checking of current token (need JWT)
	return user_info.token
	
func _get_user_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	print({
		"token": result_body.idToken,
		"id": result_body.localId,
		"refresh_token": result_body.refreshToken
	})
	
	return {
		"token": result_body.idToken, 
		"id": result_body.localId,
		"refresh_token": result_body.refreshToken
	}

func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])

func login(email: String, password: String) -> bool:
	var body:= {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	self.http.request(LOGIN_URL, [], false,HTTPClient.METHOD_POST, to_json(body))
	var result:= yield(http, "request_completed") as Array
	print(result)
	if result[1] ==200:
		user_info = _get_user_info(result)
		print("successsful login")
		return true
	print("failure to login")
	return false
