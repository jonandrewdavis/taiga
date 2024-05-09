extends MultiplayerSynchronizer

@export var player: CharacterBodySoulsBase

# Player inputs
@export var sync_input_dir: Vector2
@export var sync_secondary_action: bool
@export var sync_camera_y: float

@onready var state = player.state

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	set_physics_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	set_process_unhandled_input(get_multiplayer_authority() == multiplayer.get_unique_id())
	set_process_input(get_multiplayer_authority() == multiplayer.get_unique_id())

func _physics_process(_delta):
	sync_input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	sync_camera_y = get_viewport().get_camera_3d().global_rotation.y

func _input(_event:InputEvent):
	# Update current orientation to camera when nothing pressed TODO: 
	#if !Input.is_anything_pressed():
		#current_camera = get_viewport().get_camera_3d()
	
	if _event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	## strafe toggle on/off TODO: 
	#if _event.is_action_pressed("strafe_target"):
		#set_strafe_targeting()
		
	# a helper for keyboard controls, not really used for joypad
	if Input.is_action_pressed("secondary_action"):
		sync_secondary_action = true
	else:
		sync_secondary_action = false
	
	if player.current_state == state.FREE:
		if player.is_on_floor():
			# if interactable exists, activate its action
			if _event.is_action_pressed("interact"):
				player.interact.rpc()
			
			elif _event.is_action_pressed("jump"):
				player.jump.rpc()
				
			elif _event.is_action_pressed("use_weapon_light"):
				if sync_secondary_action: # big attack for keyboard
					player.attack.rpc(sync_secondary_action)
				else:
					player.attack.rpc()
					
					
			elif _event.is_action_pressed("use_weapon_strong"):
				player.attack.rpc(sync_secondary_action) # big attack for joypad

			elif _event.is_action_pressed("dodge_dash"):
				player.dodge_or_sprint.rpc()
				
			elif _event.is_action_released("dodge_dash") \
			&& player.sprint_timer.time_left:
				player.dodge.rpc()
			
			elif _event.is_action_pressed("change_primary"):
				player.weapon_change.rpc()
			elif _event.is_action_pressed("change_secondary"):
				player.gadget_change.rpc()

			elif _event.is_action_pressed("use_gadget_strong"): 
					player.use_gadget.rpc()
					
			elif _event.is_action_pressed("use_gadget_light"):
				if sync_secondary_action:
					player.use_gadget.rpc()
				else:
					player.start_guard.rpc()
			
			elif _event.is_action_pressed("change_item"):
				player.item_change.rpc()
			elif _event.is_action_pressed("use_item"): 
				player.use_item.rpc()
		else: # if not on floor
			if _event.is_action_pressed("use_weapon_light"):
				player.air_attack.rpc()
	
	elif player.current_state == state.SPRINT:
		
		if _event.is_action_released("dodge_dash"):
			player.end_sprint.rpc()
			
		elif _event.is_action_pressed("jump"):
				player.jump.rpc()
				
	elif player.current_state == state.LADDER:
		if _event.is_action_pressed("dodge_dash"):
			player.current_state = state.FREE
				
	if _event.is_action_released("use_gadget_light"):
		if not sync_secondary_action:
			player.end_guard.rpc()
