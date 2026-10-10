extends Node


@export var android_plugin: AndroidGeolocationPlugin 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	'''
		if Engine.has_singleton("GeolocationPlugin"):
			android_plugin = Engine.get_singleton("GeolocationPlugin")
			android_plugin.android_location_updated.connect(self._on_location_update)
		else:
			print("Android plugin not found!")'''
	android_plugin.android_location_permission_updated.connect(self._on_location_permission)
	android_plugin.android_location_updated.connect(self._on_location_update)

		#android_plugin.android_location_updated.connect(self._on_location_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_listening = android_plugin._is_listening_for_geolocation_updates()
	$Label.text = str('Is Listening: ', is_listening)
	
func _on_location_update(location_dictionary: Dictionary) -> void:
	var latitude: float = location_dictionary["latitude"]
	var longitude: float = location_dictionary["longitude"]
	$Label.text = str('Location Update: Latitude[', latitude, '], Longitude[', longitude, ']')
func lokaizacja():
	pass






func _on_button_pressed() -> void:
	android_plugin._request_location_permission()
	#$Label.text = "snoh"
	$Label.text = android_plugin._ping()
	#android_plugin.android_location_updated.connect(self._on_location_update)
	
	




func _on_button_2_pressed() -> void:
	$Label.text = "assadfadsfdf"
	var minTimeMs: int = 5000
	var minDistanceM: float = 0.0
	var plugin_result = android_plugin._start_geolocation_listener(minTimeMs, minDistanceM)
	$Label.text = str('Started listinening: ', plugin_result)


func _on_button_3_pressed() -> void:
	$Label.text = android_plugin._ping()
	android_plugin.android_location_permission_updated.connect(self._on_location_permission)
	
func _on_location_permission(granted: bool) -> void:
	$Label2.text = str('Location permission: ', granted)

func _on_button_4_pressed() -> void:
	pass
