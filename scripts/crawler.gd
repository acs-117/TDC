extends CharacterBody2D


@export var speed : float = 120.0
@export var jump_force: float = 180
@export var gravity: float = 5.0
@export var detection_radius : float = 200.0
@export var leap_time: int  = 25
var leap_animation: int = 0

@export var health: int = 25
@export var crawler_damage: int = 10
@export var crawler_is_hit: bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $"../../UI/HUD/HealthBar"
@onready var leap: AudioStreamPlayer2D = $Leap
@onready var hurt: AudioStreamPlayer2D = $Hurt

var player : CharacterBody2D = null
@export var blood_scene : PackedScene


func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	
	# gets node of current weapon
	

func _physics_process(_delta: float) -> void:
	#print(crawler_is_hit)
	
	if player:

		var direction = player.global_position - global_position
		if direction.length() < detection_radius:
			set_physics_process(true)
			direction = direction.normalized()
			if direction.x > 0:
				animated_sprite.flip_h = false
			elif direction.x < 0:
				animated_sprite.flip_h = true
			if is_on_floor():
				velocity.x = 0
				animated_sprite.play("crawler_floor")
				leap_animation += 1
				if leap_animation == leap_time:
					leap.play()
					crawler_is_hit = false
					velocity.y = -jump_force
					animated_sprite.play("crawler_leap")
					leap_animation = 0
			elif not is_on_floor():
				velocity.y += gravity
				velocity.x = direction.x * speed
				
				# if crawler is it hit
				if crawler_is_hit:
					animated_sprite.play("crawler_hurt")
					var blood = blood_scene.instantiate()
					blood.emitting = true
					get_parent().add_child(blood)
					blood.position = position
			
				
				
		else:
			velocity = Vector2.ZERO 
		
		move_and_slide()
		
# killing the enemy with a projectile by a made group


func _on_hitbox_body_entered(body):


	if body.is_in_group("projectile"):
		var current_weapon = player.active_weapon
		health -= current_weapon.damage
		#for blood effect
		crawler_is_hit = true
		hurt.play()
			

		if health <= 0:
			queue_free()
	if body.is_in_group('Player'):
		player.hp -= crawler_damage
		Singleton.player_hit.emit()
		# for player health beeping effect
		player.health_beeping.emit()
		


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group('Explosion'):
		crawler_is_hit = true
		hurt.play()
		queue_free()
