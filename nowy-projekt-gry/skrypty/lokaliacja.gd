extends Node


@export var android_plugin: AndroidGeolocationPlugin 
@export var log_label: Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	android_plugin.android_location_updated.connect(self._on_location_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_location_update(location_dictionary: Dictionary) -> void:
	var latitude: float = location_dictionary["latitude"]
	var longitude: float = location_dictionary["longitude"]
	log_label.text = str('Location Update: Latitude[', latitude,'], Longitude[', longitude, ']')
func lokaizacja():
	pass
	
