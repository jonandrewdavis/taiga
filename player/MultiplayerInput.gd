extends MultiplayerSynchronizer

@export var player: CharacterBodySoulsBase

# Player inputs
@export var sync_input_dir: Vector2
@export var sync_secondary_action: bool
@export var sync_camera_y: float

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	set_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func _process(_delta):
	sync_input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	sync_camera_y = get_viewport().get_camera_3d().global_rotation.y

func _input(_event:InputEvent):
	
	if _event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	## strafe toggle on/off
	if _event.is_action_pressed("strafe_target"):
		player.set_strafe_targeting.rpc()
		
	# a helper for keyboard controls, not really used for joypad
	if Input.is_action_pressed("secondary_action"):
		sync_secondary_action = true
	else:
		sync_secondary_action = false
	
	if player.current_state == player.state.FREE:
		if player.is_on_floor():
			# if interactable exists, activate its action
			if _event.is_action_pressed("interact"):
				player.interact.rpc()
			
			elif _event.is_action_pressed("jump"):
				player.jump.rpc()
				
			elif _event.is_action_pressed("use_weapon_light"):
				if sync_secondary_action: # big attack for keyboard
					player.attack(sync_secondary_action)
				else:
					player.attack.rpc()
					
					
			elif _event.is_action_pressed("use_weapon_strong"):
				player.attack.rpc(sync_secondary_action) # big attack for joypad

			elif _event.is_action_pressed("dodge_dash"):
				player.dodge_or_sprint()
				
			#elif _event.is_action_released("dodge_dash") \
			#&& sprint_timer.time_left:
				#player.dodge()
			
			elif _event.is_action_pressed("change_primary"):
				player.weapon_change.rpc()
			elif _event.is_action_pressed("change_secondary"):
				player.gadget_change.rpc()

			elif _event.is_action_pressed("use_gadget_strong"): 
					player.use_gadget.rpc()
					
			elif _event.is_action_pressed("use_gadget_light"):
				if sync_secondary_action:
					player.use_gadget()
				else:
					player.start_guard.rpc()
			
			elif _event.is_action_pressed("change_item"):
				player.item_change.rpc()
			elif _event.is_action_pressed("use_item"): 
				player.use_item.rpc()
		else: # if not on floor
			if _event.is_action_pressed("use_weapon_light"):
				player.air_attack.rpc()
	
	elif player.current_state == player.state.SPRINT:
		
		if _event.is_action_released("dodge_dash"):
			player.end_sprint.rpc()
			
		elif _event.is_action_pressed("jump"):
				player.jump.rpc()
				
	elif player.current_state == player.state.LADDER:
		if _event.is_action_pressed("dodge_dash"):
			player.current_state = player.state.FREE
				
	if _event.is_action_released("use_gadget_light"):
		if not sync_secondary_action:
			player.end_guard.rpc()
