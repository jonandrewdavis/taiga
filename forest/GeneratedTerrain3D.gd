extends Node

# NOTE CHANGE:
@export var generated_heightmap: Image
@export var generated_scale: float
@export var terrain: Terrain3D = Terrain3D.new()

func _ready():
	#$UI.player = $Player

	# Create a terrain
	terrain.set_collision_enabled(false)
	terrain.storage = Terrain3DStorage.new()
	terrain.texture_list = Terrain3DTextureList.new()
	terrain.name = "GeneratedTerrain3D"
	add_child(terrain, true)
	
	# TODO: Add
	terrain.material.world_background = Terrain3DMaterial.NONE
	
	# Generate 32-bit noise and import it with scale
	var noise := FastNoiseLite.new()
	noise.frequency = 0.0005
	var img: Image = Image.create(2048, 2048, false, Image.FORMAT_RF)
	for x in 2048:
		for y in 2048:
			img.set_pixel(x, y, Color(noise.get_noise_2d(x, y)*0.5, 0., 0., 1.))
	terrain.storage.import_images([img, null, null], Vector3(-1024, 0, -1024), 0.0, 300.0)
	
	# AD CHANGE: Save off 
	generated_heightmap = img
	generated_scale = 300.0
	

	# Enable collision. Enable the first if you wish to see it with Debug/Visible Collision Shapes
	#terrain.set_show_debug_collision(true)
	terrain.set_collision_enabled(true)
	
	# Enable runtime navigation baking using the terrain
	await get_tree().create_timer(2.0).timeout

	print('BAKE TIME')

	# Enable runtime navigation baking using the terrain
	# TEST
	$NavigationBaker.terrain = terrain
	$NavigationBaker.enabled = true
		
	# Retreive 512x512 region blur map showing where the regions are
	var rbmap_rid: RID = terrain.material.get_region_blend_map()
	img = RenderingServer.texture_2d_get(rbmap_rid)
	#$UI/TextureRect.texture = ImageTexture.create_from_image(img)

		

