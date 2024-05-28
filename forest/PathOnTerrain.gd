extends Path3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var hmap_img: Image
var width: int
var height: int
var heightmap_scale: float

@export var terrain_height_adjust: float = 1 #const

func _on_generated_terrain_3d_ready_bake():
	prepare_terrain_data()

func prepare_terrain_data():
	hmap_img = GlobalState.current_heightmap
	heightmap_scale = GlobalState.current_terrain_scale
	width = hmap_img.get_width()
	height = hmap_img.get_height()
	
	await get_tree().create_timer(1.0).timeout
	attach_points_to_heightmap()
		
# TODO: a wider margin in the sky for the Instancers to sample & avoid :) 
# TODO: on the last one, place the ending : ) 
func attach_points_to_heightmap():
	curve.clear_points()
	for i in range(980):
		curve.add_point(Vector3(i * 2, 0, 0))

		
	# TODO: "Pathfinding": search along points and find the least slope for each point
	print('ATTACHING')
	for i in curve.get_point_count():
		var point = curve.get_point_position(i)
		var new_y = get_heightmap_y(point.x, point.z)
		# TODO: this static measurement on titlt
		print(point.x,  ', z: ', point.z)
		var tilt_right = get_heightmap_y(point.x, point.z + 1)

		curve.set_point_position(i, Vector3(point.x, new_y + terrain_height_adjust, point.z))		
		
		if (new_y > tilt_right):
			curve.set_point_tilt(i, (new_y - tilt_right))
		else:
			curve.set_point_tilt(i, -(tilt_right - new_y))

		#print(curve.get_point_tilt(i))
		#curve.set_point_tilt(i, 0.2)
		
func get_heightmap_y(x, z):
	var i : float = 2.0
	var pixel_x = (width / i) + x
	var pixel_z = (height / i) + z
	
	if pixel_x > width: pixel_x -= width 
	if pixel_z > height: pixel_z -= height 
	if pixel_x < 0: pixel_x += width 
	if pixel_z < 0: pixel_z += height 
 	
	var color: Color = hmap_img.get_pixel(pixel_x, pixel_z)
	
	# NOTE: The secret key here was the scaling factor (* 300.0) for generated terrain
	# TODO: Rename terrain_height to terrain_height (negative), cause I'm using to subtract
	return (color.r * (heightmap_scale * 1))
