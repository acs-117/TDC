extends CharacterBody2D


@export var speed = 50
@export var detection_radius : float = 100
@export var too_close = 100
@export var fire_timer = 5
@export var bomb_speed = 100
var timer = 0

@export var health: int = 25
#@export var bomber_damage: int = 10
var bomber_is_hit: bool = false
var is_shield = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $"../../UI/HUD/HealthBar"
@onready var rotator: Node2D = $Rotator
@onready var shield: Sprite2D = $Shield

var player : CharacterBody2D = null
@export var blood_scene : PackedScene
@export var bomb_scene : PackedScene
var bomb = null
@onready var hurt: AudioStreamPlayer2D = $Hurt

func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	# gets node of current weapon


func _physics_process(_delta: float) -> void:
	#print(global_rotation)
	
	if player:

		var direction = player.global_position - global_position
		if direction.length() < detection_radius:
			#var collision = move_and_collide(velocity)
			if direction.length() > too_close:
				direction = direction.normalized()
				velocity = direction * speed
			else:
				velocity = Vector2(0,0)
			rotator.look_at(player.position)

			timer += _delta
			print(is_shield)
			
			if timer > randi_range(3,5):
				if global_rotation < 0 and is_instance_valid(bomb) :
					bomb.global_rotation += PI
				eject_bomb()
				shield_working()
				timer = 0


		else:
			velocity = Vector2.ZERO 
		
		
		move_and_slide()


func eject_bomb() -> void:
	bomb = bomb_scene.instantiate() as RigidBody2D
	bomb.speed = bomb_speed
	bomb.global_position = rotator.global_position
	bomb.global_rotation = rotator.global_rotation
	rotator.get_tree().current_scene.add_child(bomb)


func shield_working():
	if is_shield:
		is_shield = false
		shield.visible = false
	else:
		is_shield = true
		shield.visible = true

	
func _on_hit_box_body_entered(body: Node2D) -> void:
	var current_weapon = player.active_weapon
	if body.is_in_group("projectile") and is_shield == false:
		health -= current_weapon.damage
		#for blood effect
		bomber_is_hit = true
		var blood = blood_scene.instantiate()
		blood.emitting = true
		get_parent().add_child(blood)
		blood.position = position
		hurt.play()

		if health <= 0:
			queue_free()
