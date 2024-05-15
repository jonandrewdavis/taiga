@tool
extends GPUParticles3D

@export var player_node: Node3D
@export var generated_terrain: Node

var timer = Timer.new()
var update_frequency = 0.2

# NOTE: Do not screw with the terrain amplitude for this node.

# Called when the node enters the scene tree for the first time.
func _ready():

	if Engine.is_editor_hint():
		print("GRASS IN EDITOR")
		global_position = Vector3(0,0,0)
		create_instance()
		return
	else:
		global_position = Vector3(0,0,0)
		var players = get_tree().get_nodes_in_group("Player");
		if players.size():
			player_node = players[0]
			print(player_node)
			await get_tree().create_timer(2.0).timeout
			create_instance()
		else:
			await get_tree().create_timer(2.0).timeout
			_ready()
	pass # Replace with function body.


func create_instance():
	global_position = Vector3(0,0,0)
	if Engine.is_editor_hint():
		pass
	else: 
		var get_new_map = ImageTexture.create_from_image(generated_terrain.generated_heightmap)
		if !get_new_map:
			return
		process_material.set("shader_parameter/map_heightmap", get_new_map);
	
	#Add timer for updates
	add_child(timer)
	timer.wait_time = update_frequency 
	timer.autostart = true 
	timer.timeout.connect(_update)
	_update()

func _update():
	#on each update, move the center to player
	self.global_position = Vector3(player_node.global_position.x,0.0,player_node.global_position.z).snapped(Vector3(1,0,1));
	timer.start()
