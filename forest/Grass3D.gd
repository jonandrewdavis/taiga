extends GPUParticles3D

@export var player_node: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	print('READY')
	if Engine.is_editor_hint():
		create_instance()
		return
	else:
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

var timer

func create_instance():
	print("CREATE GRASS CALLED")
	timer = Timer.new()
	$"..".add_child(timer)
	timer.timeout.connect(_update)
	timer.wait_time = 0.1 
	_update()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update():
	#on each update, move the center to player
	self.global_position = Vector3(player_node.global_position.x,0.0,player_node.global_position.z).snapped(Vector3(1,0,1));
	timer.wait_time = 0.1
	timer.start()
