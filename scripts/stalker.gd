extends CharacterBody2D

@export var speed : float = 120.0
@export var detection_radius : float = 150.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $"../../UI/HUD/HealthBar"
@onready var charge: AudioStreamPlayer2D = $Charge
@onready var hurt: AudioStreamPlayer2D = $Hurt

@export var gravity = 250
@export var health : int = 40
@export var stalker_damage: int = 10
@export var blood_timer: int = 10
var timer = 0
var stalker_is_hit = false
var player_detected: bool =false

var player : CharacterBody2D = null
var weapon : CharacterBody2D = null
@export var blood_scene : PackedScene

func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	weapon = get_tree().root.get_node("SpaceShip/Player/Weapon")
	#connect("body_entered", self, "_on_Area2D_body_entered")

func _physics_process(_delta: float) -> void:
	
	if player:
		var direction = player.global_position - global_position
		if direction.length() < detection_radius:
			direction = direction.normalized()
			#print(direction.x)
			velocity.x = direction.x * speed
			if not player_detected:
				charge.play()
				player_detected = true
			if is_on_floor():
				velocity.y = 0
			else:
				velocity.y = gravity
			animated_sprite.play("stalker_run")
			if direction.x > 0:
				animated_sprite.flip_h = false
			elif direction.x < 0:
				animated_sprite.flip_h = true
			
			if stalker_is_hit:
				bleed()
				timer += 1
			if timer > blood_timer:
				stalker_is_hit = false
				timer = 0
		
		else:
			velocity = Vector2.ZERO 
			animated_sprite.play("stalker_idle")
			player_detected = false
		
		move_and_slide()
		
# killing the enemy with a projectile by a made group

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("projectile"):
		var current_weapon = player.active_weapon
		health -= current_weapon.damage
		#for blood effect
		stalker_is_hit = true
		hurt.play()

		if health <= 0:
			queue_free()


func bleed():
	var blood = blood_scene.instantiate()
	blood.emitting = true
	get_parent().add_child(blood)
	blood.position = Vector2(position.x, position.y -10)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		player.hp -= stalker_damage
		Singleton.player_hit.emit()
		# for player health beeping effect
		player.health_beeping.emit()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group('Explosion'):
		stalker_is_hit = true
		hurt.play()
		queue_free()
