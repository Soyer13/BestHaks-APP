extends GridContainer

var zoom: int = 16

var current_center_x: int = 0
var current_center_y: int = 0

const TILE_SIZE = 256 
var tiles_cache = {}

func _ready():
	columns = 5 
	add_theme_constant_override("h_separation", 0)
	add_theme_constant_override("v_separation", 0)
	
	#sciezka do kamery
	var kamera = $"../Camera2D" 
	
	if kamera:
		kamera.on_tile_changed.connect(_on_camera_changed_tile)

	for y in range(5):
		for x in range(5):
			var tile_display = TextureRect.new()
			tile_display.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE) 
			add_child(tile_display)
			
			var cache_key = str(x) + "_" + str(y)
			tiles_cache[cache_key] = tile_display
			
			var http_req = HTTPRequest.new()
			tile_display.add_child(http_req)

	current_center_x = 37016
	current_center_y = 21508
	
	position.x = -(TILE_SIZE * 2)
	position.y = -(TILE_SIZE * 2)
	
	load_5x5_map(current_center_x, current_center_y)

func _on_camera_changed_tile(offset_x: int, offset_y: int):
	#zmiana aktualnego chunk centrum
	current_center_x += offset_x
	current_center_y += offset_y
	
	# Przesuwamy fizycznie siatkę mapy, aby zawsze znajdowała się pod kamerą
	position.x += offset_x * TILE_SIZE
	position.y += offset_y * TILE_SIZE
	
	load_5x5_map(current_center_x, current_center_y)

# ladowanie (cie w dupe) fov
func load_5x5_map(center_tile_x: int, center_tile_y: int):
	for grid_y in range(5):
		for grid_x in range(5):
			var logic_x = center_tile_x + (grid_x - 2)
			var logic_y = center_tile_y + (grid_y - 2)
			
			# pobieranie adresu kafelka centrum
			var url = get_tile_url(logic_x, logic_y, zoom)
			update_specific_tile(grid_x, grid_y, url)

# miejsce na api mapy
func get_tile_url(tile_x: int, tile_y: int, z: int) -> String:
	#
	return "https://tile.openstreetmap.org/%d/%d/%d.png" % [z, tile_x, tile_y]
	# return "" 

func update_specific_tile(grid_x: int, grid_y: int, url: String):
	if url == "":
		return
		
	var cache_key = str(grid_x) + "_" + str(grid_y)
	var tile_display = tiles_cache[cache_key]
	
	var http_request = tile_display.get_child(0)
	
	http_request.cancel_request()
	
	if http_request.request_completed.is_connected(_on_tile_downloaded):
		http_request.request_completed.disconnect(_on_tile_downloaded)
		
	http_request.request_completed.connect(_on_tile_downloaded.bind(tile_display))
	
	var headers = ["User-Agent: NaszaGra/1.0"]
	http_request.request(url, headers)

func _on_tile_downloaded(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, target_display: TextureRect):
	if response_code == 200:
		var image = Image.new()
		var err = image.load_png_from_buffer(body) 
		if err == OK:
			target_display.texture = ImageTexture.create_from_image(image)
		else:
			print("Błąd parsowania obrazka.")
