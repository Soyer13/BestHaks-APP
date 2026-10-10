extends Node

var http_request: HTTPRequest

func _ready():
	callAPI("https://ipapi.co/json/")




func callAPI(calling_API: String):
	http_request = HTTPRequest.new()
	add_child(http_request)
	# Podłączenie sygnału
	http_request.request_completed.connect(_on_request_completed)
	# Wysyłanie zapytania
	fetch_api_data(calling_API)


func fetch_api_data(url: String):
	var error = http_request.request(url)
	if error != OK:
		print("Błąd wysyłania zapytania: ", error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		print("Pobrane dane: ", json.data)
