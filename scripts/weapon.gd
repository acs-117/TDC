extends CharacterBody2D

@onready var gun_end = $GunEnd
@onready var weapon_image = $WeaponImage
@onready var weapon: CharacterBody2D = $"."
@onready var interactable_area = $InteractableArea
@onready var collision_shape = $CollisionShape2D
@onready var plasma_shot: AudioStreamPlayer2D = $PlasmaShot
@onready var gun_shot: AudioStreamPlayer2D = $GunShot
@onready var gun_shot_2: AudioStreamPlayer2D = $GunShot2
@onready var gun_shot_3: AudioStreamPlayer2D = $GunShot3
@onready var plasma_shot_2: AudioStreamPlayer2D = $PlasmaShot2
@onready var explosion: AudioStreamPlayer2D = $GrenadeNodes/Explosion
@onready var light: PointLight2D = $PointLight2D

@export var damage: int = 5
@export var fire_rate: int = 20
@export var fire_range: int = 200
@export var bullet_speed: int = 500
var gun_end_pos = null

var shoot_cooldown: int = 1
var can_shoot: bool  = true
var shoot_direction: float = 1
var is_picked_up: bool = false
var is_weapon_droped: bool = false
var is_interactable: bool = false
var is_interacting: bool = false
var holster_rotation = 90
#whetehr handgun or rifle
@export var is_handgun: bool = false
@export var is_rifle: bool = false


@export var light_bullet_scene : PackedScene
@export var heavy_bullet_scene : PackedScene
@export var plasma_bullet_scene : PackedScene
@export var muzzle_flash_scene: PackedScene
#@export var ammo_scene: PackedScene

var player = null
var player_arms = null
var holster = null
signal player_has_shot

#grenade variables
@onready var grenade_nodes: Area2D = $GrenadeNodes
@onready var explosion_area: CollisionShape2D = $GrenadeNodes/ExplosionArea
@onready var grenade_light: PointLight2D = $GrenadeNodes/GrenadeLight
@export var is_grenade : bool = false
@export var grenade_timer = 60
var grenade_activated : bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $GrenadeNodes/AnimatedSprite2D
@onready var explosion_light: PointLight2D = $GrenadeNodes/ExplosionLight
signal greande_exploded

# which weapon is it
@export var stitch_N49: bool = false
@export var point_rifle_M6: bool = false
@export var blood_shot: bool = false
@export var melting_pistol: bool = false
@export var plasma_bolt_action: bool = false
var bullet = null


func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	player_arms = get_tree().root.get_node("SpaceShip/Player/player_sprites/WeaponHolder")
	holster = get_tree().root.get_node("SpaceShip/Player/player_sprites/HolsterHolder")
	#weapon = get_tree().root.get_node("SpaceShip/Player/Weapon")
	which_weapon()
	#current_weapon = player.get_child(7)

func _physics_process(delta):
	#print(player.active_weapon)
	#var current_weapon = player.get_child(7)
	#print(gun_end_pos)
	#var mouse_pos = get_local_mouse_position().x
	ammo_is_available()
	#shoot direction
	if is_picked_up:
		#print(gun_end.position.y)
		#weapon.position = Vector2.ZERO
		if player.is_player_right == false:
			weapon_image.flip_h = true
			shoot_direction = -1
			if player.weapon_carry_count == 2:
				holster_rotation = -90
			
		elif player.is_player_right:
			weapon_image.flip_h = false
			shoot_direction = 1
			if player.weapon_carry_count == 2:
				holster_rotation = 90
			
		
	# crouched shooting
	weapon_y_pos()

	update_weapon_roles()
	
	# weapon pickup
	if Input.is_action_pressed("interact") and is_interactable and player.weapon_carry_count <= 1:
		# makes gun the parent of player
		
		player.non_interaction(self)
		remove_from_group("Interactable")
		var current_parent = self.get_parent()
		current_parent.remove_child(self)
		
		if player.active_weapon == null:
			player.active_weapon = self
			player_arms.add_child(self)
		else:
			player.holstered_weapon = self
			holster.add_child(self)
			
		#print("New parent: ", self.get_parent())
		self.global_position = player.global_position 
		is_picked_up = true
		collision_shape.disabled = true
		# so that we dont carry multiple weapons
		player.weapon_carry_count += 1
		
		Singleton.weapon_switched.emit()


	grenade_explosion()
	weapon_drop()
	
	if is_picked_up == false:
		velocity.y += 10
	if is_on_floor():
		velocity = Vector2.ZERO
		
	move_and_slide()

	
	
func shoot() -> void:
	if self == player.active_weapon:
		player.trigger_shake()
		bullet_selection()
		
		var muzzle_flash = muzzle_flash_scene.instantiate()
		
		bullet.global_position = gun_end.global_position
		bullet.global_rotation = gun_end.global_rotation  # Use gun_end if it points the right way
		
		if not player.is_player_right:
			bullet.global_rotation += PI
		
		muzzle_flash.global_position = gun_end.global_position
		
		get_tree().current_scene.add_child(bullet)
		get_tree().current_scene.add_child(muzzle_flash)
		
	
func bullet_selection():
	if stitch_N49:
		bullet = light_bullet_scene.instantiate() as CharacterBody2D
		gun_shot.play()
		player.max_shake = 2.0
	elif point_rifle_M6:
		bullet = heavy_bullet_scene.instantiate() as CharacterBody2D
		gun_shot_2.play()
		player.max_shake = 3.5
	elif blood_shot:
		bullet = heavy_bullet_scene.instantiate() as CharacterBody2D
		gun_shot_3.play()
		player.max_shake = 5.0
	elif melting_pistol:
		bullet = plasma_bullet_scene.instantiate() as CharacterBody2D
		plasma_shot.play()
		player.max_shake = 1.0
	elif plasma_bolt_action:
		bullet = plasma_bullet_scene.instantiate() as CharacterBody2D
		plasma_shot_2.play()
		player.max_shake = 2.0
	
func weapon_drop():
	
	if Input.is_action_just_pressed("drop") and is_picked_up :
		#print('yea')

		add_to_group("Interactable")
		# makes gun unparent the player
		if self == player.active_weapon:
			var current_parent = self.get_parent()
			current_parent.remove_child(self)
			player.get_parent().add_child(self)
				
			is_weapon_droped = true
			player.weapon_carry_count -= 1
			self.global_position = player.global_position
			collision_shape.disabled = false
			velocity.y -= 100
			if player.is_player_right:
				velocity.x += 350
			else:
				velocity.x -= 350
			is_picked_up = false
			player.active_weapon = null
			
			Singleton.suit_up.emit()


func update_weapon_roles():
	if is_picked_up:
		if self == player.active_weapon:
			set_as_top_level(false)
			weapon.z_index = 1
			player.active_weapon.rotation = deg_to_rad(0)
			if is_handgun:
				weapon.position.x  = 18 * shoot_direction
				gun_end.position.x = 15 * shoot_direction 
			elif is_rifle:
				weapon.position.x  = 16 * shoot_direction
				collision_shape.scale = Vector2(2 ,2)
				gun_end.position.x = 23 * shoot_direction 
			elif is_grenade:
				weapon.position.x = 11 * shoot_direction 
				if not grenade_activated:
					grenade_light.energy = 20
	
	if self == player.holstered_weapon:
		#global_position = player.global_position
		weapon.z_index = 0
		player.holstered_weapon.rotation = deg_to_rad(holster_rotation)
		if is_handgun:
			weapon.position.x  = -6 * shoot_direction 
			gun_end.position.x = 20 * shoot_direction
		elif is_rifle:
			weapon.position.x  = -6 * shoot_direction
			collision_shape.scale = Vector2(2 ,2)
			gun_end.position.x = 23 * shoot_direction 
		elif is_grenade:
			weapon.position.x = -6 * shoot_direction 
			if not grenade_activated:
				grenade_light.energy = 20


func weapon_y_pos():
	
	if self == player.active_weapon:
		weapon.position.y = -2
		gun_end.position.y = -1
	elif self == player.holstered_weapon:
		weapon.position.y = -2
		gun_end.position.y = -1


func grenade_explosion():

	if player.active_weapon != null:
		if player.active_weapon.is_grenade:
			if Input.is_action_pressed("shoot"):
				player.active_weapon.grenade_activated = true
				
	if grenade_activated:
		grenade_light.energy = 0
		grenade_timer -=1
		if grenade_timer <= 0:
			player.max_shake = 12.0
			player.trigger_shake()
			if explosion_area.disabled:
				greande_exploded.emit()
			explosion_area.disabled =false
			explosion_light.energy = 2
			animated_sprite_2d.play()
			velocity = Vector2.ZERO
			
		# time at which the grenade dissapears after detonation
			if grenade_timer <-25 :
				queue_free()
	
func ammo_is_available():
	# remember to connect this signal from player node to here on new weapon
		# kept outside is_picked up so that it counts down even when not at hand
	# shoot cooldown
	#print(shoot_cooldown)
	if Input.is_action_pressed("shoot") and can_shoot and self == player.active_weapon and not is_grenade and not Singleton.ui_active:
		if player.ammo_availability():
			shoot()
			shoot_cooldown = fire_rate
			player_has_shot.emit()
			can_shoot = false
	shoot_cooldown -=1
	if shoot_cooldown == 0:
		can_shoot = true
		shoot_cooldown = 1


func which_weapon():
	if stitch_N49:
		weapon_image.texture = load("res://assets/sprites/weapons/stitch_N49.png")
	elif point_rifle_M6:
		weapon_image.texture = load("res://assets/sprites/weapons/point_rifle2.png")
	elif melting_pistol:
		weapon_image.texture = load("res://assets/sprites/weapons/melting_pistol.png")
	elif blood_shot:
		weapon_image.texture = load("res://assets/sprites/weapons/blood_shot.png")
	elif plasma_bolt_action:
		weapon_image.texture = load("res://assets/sprites/weapons/plasma_sniper.png")
	elif is_grenade:
		weapon_image.texture = load("res://assets/sprites/weapons/mini_atomizer.png")


func _on_interactable_area_body_entered(body):
	# weapon pickup
	if body.is_in_group("Player") and is_picked_up ==false and player.weapon_carry_count < 2:
		is_interactable = true
		

func _on_interactable_area_body_exited(body):
	is_interactable = false
