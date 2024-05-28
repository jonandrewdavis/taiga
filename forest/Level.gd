extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(prepare_player_environment_scenes)
	pass # Replace with function body.

func prepare_player_environment_scenes(arg):
	print('heard chef', arg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
