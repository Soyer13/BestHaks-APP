extends Node

var gps_provider

# Przeciągnij tutaj swoje węzły z edytora Godota (lub przypisz je przez kod)



func _ready() -> void:
	# Podłączenie sygnału uprawnień
	get_tree().on_request_permissions_result.connect(permCheck)
	
	


func permCheck(permName: String, wasGranted: bool) -> void:
	if permName == "android.permission.ACCESS_FINE_LOCATION" and wasGranted:
		enableGPS()

func enableGPS() -> void:
	if Engine.has_singleton("PraxisMapperGPSPlugin"):
		gps_provider = Engine.get_singleton("PraxisMapperGPSPlugin")
		if gps_provider != null:
			if not gps_provider.onLocationUpdates.is_connected(_on_location_updates):
				gps_provider.onLocationUpdates.connect(_on_location_updates)
			
			gps_provider.StartListening()
			if $Label:
				$Label.text = "Nasłuchiwanie GPS..."
	else:
		print("PraxisMapperGPSPlugin działa tylko na urządzeniu Android.")
		if $Label:
			$Label.text = "Brak wtyczki GPS (tryb testowy PC)."

# Odbieranie danych z pluginu i wyświetlanie na ekranie
func _on_location_updates(location_data: Dictionary) -> void:
	var latitude = location_data.get("latitude", 0.0)
	var longitude = location_data.get("longitude", 0.0)
	var accuracy = location_data.get("accuracy", 0.0)

	# Formatowanie tekstu lokalizacji
	var info_text = "Szerokość: " + str(latitude) + "\nDługość: " + str(longitude) + "\nDokładność: " + str(accuracy) + " m"
	
	# Wypisanie w konsoli oraz przypisanie do etykiety (Label)
	print(info_text)
	if $Label != null:
		$Label.text = info_text


func _on_button_5_pressed() -> void:
	print("Kliknięto przycisk - żądanie uprawnień i start GPS...")
	var allowed = OS.request_permissions() 
	if allowed:
		enableGPS()
