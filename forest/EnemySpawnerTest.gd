extends Node3D


@export var enemy: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_navigation_baker_bake_finished():
	
	print('ready enemy')
	var enemy = load("res://enemy/CharacterBodyEnemyBase.tscn")
	var enemy_ready: CharacterBody3D =  enemy.instantiate()
	enemy_ready.global_position = Vector3(0, 50, 0)
	get_parent().add_child(enemy_ready, true)
	pass # Replace with function body.
