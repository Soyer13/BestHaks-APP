extends Camera2D

#zoom settings
var zoom_min=Vector2(0.5,0.5)
var zoom_max=Vector2(3,3)
var zoom_sensitivity=0.005

#zoom deadzone
var zoom_deadzone=20.0
var is_zooming=false

#touch remembering
var touches={}
var touch_distance=0.0
var touch_midpoint=Vector2.ZERO

const TILE_SIZE = 256 
var current_tile_pos = Vector2.ZERO 

#position change
signal on_tile_changed(offset_x: int, offset_y: int)

func _ready():
	zoom = Vector2(1.0, 1.0)
	current_tile_pos = get_tile_from_pixel_pos(global_position)

func _process(delta):
	#check position
	var new_tile_pos = get_tile_from_pixel_pos(global_position)
	
	if new_tile_pos != current_tile_pos:
		var offset_x = int(new_tile_pos.x - current_tile_pos.x)
		var offset_y = int(new_tile_pos.y - current_tile_pos.y)
		
		current_tile_pos = new_tile_pos
		
		on_tile_changed.emit(offset_x, offset_y)

#pixel to x/y
func get_tile_from_pixel_pos(pos: Vector2) -> Vector2:
	var tile_x = floor(pos.x / TILE_SIZE)
	var tile_y = floor(pos.y / TILE_SIZE)
	return Vector2(tile_x, tile_y)
func ready():
	zoom= Vector2(1.0,1.0)

#touch searching
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
		else:
			#delete from recent positions
			touches.erase(event.index)
		#two touches sensor
		if touches.size() == 2:
			var keys = touches.keys()
			touch_distance = touches[keys[0]].distance_to(touches[keys[1]])
			touch_midpoint = (touches[keys[0]] + touches[keys[1]])/2.0
			is_zooming = false
	elif event is InputEventScreenDrag:
		#where touch change?
		touches[event.index] = event.position
		
		#2 tiuch check
		if touches.size() == 2:
			var keys = touches.keys()
			var current_distance = touches[keys[0]].distance_to(touches[keys[1]])
			var current_midpoint = (touches[keys[0]] + touches[keys[1]])/2.0
			
			#cam move
			var midpoint_delta = current_midpoint - touch_midpoint
			position -= midpoint_delta / zoom
			touch_midpoint = current_midpoint
			
			#out/in change
			var dist_delta = current_distance - touch_distance
			
			#zoom unlock
			if not is_zooming and abs(dist_delta) > zoom_deadzone:
				is_zooming = true
				touch_distance = current_distance 
				dist_delta = 0.0
			if is_zooming:
				#change of zoom
				zoom += Vector2(dist_delta, dist_delta) * zoom_sensitivity
			
				#zoom lock
				zoom = zoom.clamp(zoom_min, zoom_max)
			
				#touch distance update
				touch_distance = current_distance
			
			
			
			
