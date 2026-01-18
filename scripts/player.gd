extends CharacterBody2D

# player health

@export var hp : float = 100.0

#player locomotion variables
@export var no_of_children = 9
@export var speed : int = 110
# NOTE: it has been changed in code for crouching and such
@export var accel : int = 10

# player direction checking
var is_player_right: bool  = true
var is_player_crouched: bool = false
var crouch_count = 0
#jumping and shit like that variables

@export var gravity : float = 20
@export var jump_force : int = 390
@export var jump_buffer_time : int = 15
@export var coyote_time : int = 15
@export var max_falling_speed : int = 1000
# 0 for disabling and 1 for enabling double jump
@export var enable_double_jump : int = 1
var jump_buffer_counter : int = 0
var coyote_counter : int = 0
var jump_counter: int = 1
var footstep_counter:int = 20

# ammo and weapon variables

@export var light_ammo_count = 0
@export var heavy_ammo_count = 0
@export var plasma_ammo_count = 0
var weapon_carry_count: int = 0

@onready var light_ammo_label: Label = $"../UI/HUD/LightAmmoLabel"
@onready var heavy_ammo_label: Label = $"../UI/HUD/HeavyAmmoLabel"
@onready var plasma_ammo_label: Label = $"../UI/HUD/PlasmaAmmoLabel"

var current_weapon_node = null

var active_weapon = null
var holstered_weapon = null

@export var light_ammo = 0
@export var heavy_ammo = 0
@export var plasma_ammo = 0
#hp
@onready var health_bar = $"../UI/HUD/HealthBar"

# pushing
#@export var push_force = 80.0

# camera

@export var max_shake: float  = 1.0
@export var shake_fade: float = 10.0
var shake_strength: float = 0.0

# imported nodes

@onready var player_sprites = $player_sprites
@onready var head = $player_sprites/Head
@onready var body = $player_sprites/Body
@onready var front_arm: AnimatedSprite2D = $player_sprites/FrontArm
@onready var back_arm = $player_sprites/BackArm
@onready var legs = $player_sprites/Legs
@onready var stand_collision = $StandCollision
@onready var crouch_collision = $CrouchCollision
@onready var footsteps = $Footsteps
@onready var no_ammo = $NoAmmo
@onready var player_cam = $PlayerCam
@onready var jump = $Jump
@onready var ray_cast_2d = $RayCast2D

@onready var weapon_holder: Node2D = $player_sprites/WeaponHolder
@onready var holster_holder: Node2D = $player_sprites/HolsterHolder

@onready var interaction_label: Label = $"../UI/HUD/InteractionLabel"
@onready var interaction_label_2: Label = $"../UI/HUD/InteractionLabel2"
var is_interact = false

#signals
signal health_beeping

@export var weapon_scene: PackedScene

var save_file = SaveFile.new()
# ----------------------functions and processes---------------------------------
func _ready() -> void:
	enable_double_jump = 1
	ray_cast_2d.enabled = true


func _physics_process(_delta):
	#print(ray_cast_2d.enabled)
	

	#print(Engine.get_frames_per_second())

	#print(enable_double_jump)
	
	if hp <= 0:
		get_tree().change_scene_to_file("res://scenes/background/death_screen.tscn")
		
	health_bar.value = hp
	# Player Movement
	# middle of mouse is 30
	var direction = Input.get_axis("left", "right")
	#print(direction)
	if not player_sprites.is_sliding:
		if direction:
			velocity.x += direction * accel
			velocity.x = clamp(velocity.x , -speed , speed)
		else:
			velocity.x = lerp(velocity.x , 0.0 , 0.2)
	
	#if not player_sprites.is_sliding:
		#velocity.x = clamp(velocity.x , -speed , speed)
	
	# on floor processes

	if is_on_floor():
		coyote_counter = coyote_time
		jump_counter = 0
		
		#movement animations and whether or not ur crouching
		
		if is_player_crouched == false and not player_sprites.is_sliding :
			crouch_count = 0
			player_sprites.position.y = 0
			speed = 110
			is_player_crouched = false
			stand_collision.disabled = false
			crouch_collision.disabled = true
			
			if direction != 0:
				if (is_player_right and Input.is_action_pressed("right")) or (is_player_right == false and Input.is_action_pressed("left")):
					legs.play("run")
				else:
					legs.play_backwards("run")
				footstep_counter -= 1
				if footstep_counter == 0:
					footsteps.play()
					footstep_counter = 20
					
			elif direction ==0 :
				legs.play("idle")
			
		elif is_player_crouched:
			speed = 80
			slide_crouch_changes()
			if direction != 0:
				legs.play("crouch_move")
			elif direction == 0:
				legs.play("crouch_idle")
		
		if Input.is_action_just_pressed("crouch") and is_player_crouched == false:
			is_player_crouched = true
		elif Input.is_action_just_pressed("crouch") and is_player_crouched:
			is_player_crouched = false
	
	# Gravity
	
	if not is_on_floor():
		stand_collision.disabled = false
		crouch_collision.disabled = true
		
		if coyote_counter > 0:
			coyote_counter -= 1
		
		# double jump and wall climbing
		
		# jump buffer means player can jump and jump later even if he is in air
		# makes jumping more responsive
		if jump_buffer_counter > 0:
			if ray_cast_2d.is_colliding():
				if ray_cast_2d.get_collider().name == "TileMap":
					coyote_counter = 1
					if not is_player_right:
						velocity.x += 500
					else:
						velocity.x -= 500
				
			elif jump_counter < enable_double_jump:
				coyote_counter = 1
				jump_counter += 1
			
		velocity.y += gravity
		
		if ray_cast_2d.is_colliding():
			#idk y it keeps crashing without the null line
			if ray_cast_2d.get_collider() != null:
				if ray_cast_2d.get_collider().name == "TileMap":
					legs.play("wall_slide")
					back_arm.play("wall_slide")
					front_arm.play("idle")
					max_falling_speed = 150
				else:
					pass

		else:
			max_falling_speed = 1000
			
		if velocity.y > max_falling_speed:
			velocity.y = max_falling_speed
			
	
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
		
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		velocity.y = -jump_force
		legs.play("jump")
		front_arm.play("jump")
		back_arm.play("jump")
		#below is the sound
		jump.play()
		jump_buffer_counter = 0
		coyote_counter = 0
	
	# variable jump height
	
	#if Input.is_action_just_released("jump"):
		#if velocity.y < 0:
			#velocity.y += 120
			
	# Direction of the Player
	if hp > 0:
		var mouse_pos = get_viewport().get_mouse_position()
	
		if mouse_pos.x > get_viewport().size.x/2:
			front_arm.position.x = -4
			weapon_holder.position.x = -4
			back_arm.position.x = 2
			is_player_right = true
			head.flip_h = false
			body.flip_h = false
			front_arm.flip_h = false
			back_arm.flip_h = false
			legs.flip_h = false
			
		else:
			front_arm.position.x = 4
			weapon_holder.position.x = 4
			back_arm.position.x = -2
			is_player_right = false
			head.flip_h = true
			body.flip_h = true
			front_arm.flip_h = true
			back_arm.flip_h = true
			legs.flip_h = true
	
	# check if facing right or left or down but values incriment every frame
	#so far only used for player cam
	
	if is_player_right:
		ray_cast_2d.target_position.x = 8
		if player_cam.position.x != 36:
			player_cam.position.x += 3
	else:
		ray_cast_2d.target_position.x = -8
		if player_cam.position.x != -36:
			player_cam.position.x -= 3
	if is_player_crouched:
		if player_cam.position.y != 0:
			player_cam.position.y += 4
	else:
		if player_cam.position.y != -40:
			player_cam.position.y -= 4
		
	# player arm depending on gun
	
	# if no weapon
	if active_weapon == null :
		
		if velocity.y == 0:
			# if standing still
			if direction == 0:
				front_arm.play("idle")
				back_arm.play("idle")
			# if moving while on floor
			elif direction != 0:
				front_arm.play("running")
				back_arm.play("running")
		
	else:
		if active_weapon.is_handgun:
			front_arm.play("handgun")
			back_arm.play("handgun")
		elif active_weapon.is_rifle:
			front_arm.play("rifle")
			back_arm.play("rifle")
		elif active_weapon.is_grenade:
			front_arm.play("idle")
			back_arm.play("handgun")
	# check if there is ammo in gun
	
	#if ammo_availability():
		#ammo_is_available.emit()
	#else:
		#if Input.is_action_just_pressed("shoot") and active_weapon != null:
			#no_ammo.play()
	
	#cam shake
	if shake_strength > 0:
		shake_strength = lerp(shake_strength , 0.0 , shake_fade * _delta)
		player_cam.offset = Vector2(randf_range(-shake_strength, shake_strength) , randf_range(-shake_strength, shake_strength))
		
	player_sprites.sliding(_delta)
	weapon_switch()
	move_and_slide()


func weapon_switch():
	if Input.is_action_just_pressed("switch") and weapon_carry_count > 0:
		
		weapon_holder.remove_child(active_weapon)
		holster_holder.remove_child(holstered_weapon)
		
		var temp = active_weapon
		active_weapon = holstered_weapon
		holstered_weapon = temp
		
		weapon_holder.add_child(active_weapon)
		holster_holder.add_child(holstered_weapon)
		
		Singleton.weapon_switched.emit()
		


func ammo_availability():
	if active_weapon != null:
		if light_ammo_count > 0 and active_weapon.is_in_group('light weapon'):
			return true
		elif heavy_ammo_count > 0 and active_weapon.is_in_group('heavy weapon'):
			return true
		elif plasma_ammo_count > 0 and active_weapon.is_in_group('plasma weapon'):
			return true
		elif Input.is_action_just_pressed("shoot"):
			no_ammo.play()

#-----------------------------------------------------------------------
# signals 

#func _on_ammo_body_entered(body):
	#pass
	#controls increase in ammo when picking up cache
	# when adding ammo put it into a group in spaceship scene
	#if body.is_in_group("Player"):
		#light_ammo_count += 10
		#light_ammo_label.text = str(light_ammo_count)

func trigger_shake():
	shake_strength = max_shake
	# function used in wweapon script


func slide_crouch_changes():
	player_sprites.position.y = 12
	stand_collision.disabled = true
	crouch_collision.disabled = false


func _on_stitch_player_has_shot():
	light_ammo_count -= 1
	light_ammo_label.text = str(light_ammo_count)

func _on_point_rifle_player_has_shot():
	heavy_ammo_count -= 1
	heavy_ammo_label.text = str(heavy_ammo_count)

func _on_melting_pistol_player_has_shot() -> void:
	plasma_ammo_count -= 1
	plasma_ammo_label.text = str(plasma_ammo_count)
	
func _on_blood_shot_player_has_shot() -> void:
	heavy_ammo_count -= 1
	heavy_ammo_label.text = str(heavy_ammo_count)
	
func _on_plasma_bolt_action_player_has_shot() -> void:
	plasma_ammo_count -= 3
	plasma_ammo_label.text = str(plasma_ammo_count)



# being able to stand on boxes

func _on_player_area_body_entered(body):
	
	if body.is_in_group("box"):
		body.collision_layer = 1
		body.collision_mask = 1
		

func _on_player_area_body_exited(body):
	
	if body.is_in_group("box"):
		body.collision_layer = 8
		body.collision_mask = 8
		

func _on_grenade_player_has_shot() -> void:
	pass # Replace with function body.


# suits signals

func _on_suit_hazmat_suit_equiped() -> void:
	head.texture = load("res://assets/sprites/player/hazmat_head.png")
	body.texture = load("res://assets/sprites/player/hazmat_body.png")

func _on_suit_2_space_armor_equipped() -> void:
	head.texture = load("res://assets/sprites/player/space_head.png")
	body.texture = load("res://assets/sprites/player/space_body.png")



#interaction
func _on_player_area_area_entered(area: Area2D) -> void:
	interaction(area)
	
	if area.is_in_group('Explosion'):
		hp = 0

func _on_player_area_area_exited(area: Area2D) -> void:
	non_interaction(area)


func interaction(area):
	if area.is_in_group("Interactable") or area.get_parent().is_in_group("Interactable") :
		interaction_label.visible = true
		interaction_label_2.visible = true
		interaction_label_2.text = area.get_parent().name
	if area.get_parent().is_in_group("Interactable_Grenade"):
		interaction_label.visible = true
		interaction_label_2.visible = true
		interaction_label_2.text = "Grenade"


func non_interaction(area):
	if area.is_in_group("Interactable") or area.get_parent().is_in_group("Interactable") or area.get_parent().is_in_group("Interactable_Grenade"):
		interaction_label.visible = false
		interaction_label_2.visible = false
