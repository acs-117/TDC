extends CharacterBody2D


@export var speed : float = 300.0
@export var detection_radius : float = 300.0
@onready var health_bar = $"../../UI/HUD/HealthBar"
@onready var body = $Body
@onready var legs = $Legs
@onready var charge: AudioStreamPlayer2D = $Charge
@onready var hurt: AudioStreamPlayer2D = $Hurt


@export var health : int = 40
@export var boulder_damage: int = 30
var damage_timer: int = 60
@export var time_to_seek_player: int = 30
var is_attacked: bool  = false
@export var gravity: float = 200
var boulder_is_hit: bool = false
var bleed_time: int = 30
var player : CharacterBody2D = null
var weapon : CharacterBody2D = null
@export var blood_scene: PackedScene
var boulder_sound :bool = false


func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	#connect("body_entered", self, "_on_Area2D_body_entered")

func _physics_process(_delta: float) -> void:
	if player :
		
		_find_direction()
		velocity.y += gravity
			#animated_sprite.play("stalker_run")
			#if direction.x > 0:
				#animated_sprite.flip_h = false
			#elif direction.x < 0:
				#animated_sprite.flip_h = true
			
			#animated_sprite.play("stalker_idle")
		
		move_and_slide()
		
func _find_direction():
	
	var direction = player.global_position - global_position
	if direction.length() < detection_radius:
		direction = direction.normalized()
		print(time_to_seek_player)
		#velocity.x = direction.x * speed
		time_to_seek_player -= 1
		velocity.y += gravity
		if direction.x <0.5 and direction.x > -0.5:
			is_attacked= true
			time_to_seek_player = randi_range(30 , 120)
		
		if is_attacked :
			velocity.x = 0

		if time_to_seek_player ==0:
			velocity.x = direction.x * speed
			charge.play()
			is_attacked = false
			
		
		
		#sprites
		if direction.x  > 0:
			body.flip_h = false
			legs.flip_h = false
		else:
			body.flip_h = true
			legs.flip_h = true
			
		if velocity.x != 0:
			legs.play("run")
			if not boulder_is_hit:
				body.play("bite")
		
		else:
			legs.play('idle')
			body.play("default")
		

		if boulder_is_hit:
			body.play("boulder_hurt")
			var blood = blood_scene.instantiate()
			blood.emitting = true
			get_parent().add_child(blood)
			blood.position = position
			bleed_time -=1
			if bleed_time == 0:
				bleed_time = 30
				boulder_is_hit = false

		velocity.y = 0
	else:
		velocity = Vector2.ZERO 
	



func _on_hit_box_body_entered(body):
	
	if body.is_in_group("projectile"):
		var current_weapon = player.active_weapon
		health -= current_weapon.damage
		#for blood effect
		boulder_is_hit = true
		hurt.play()
		if health <= 0:
			queue_free()
	if body.is_in_group('Player'):
		player.hp -= boulder_damage
		Singleton.player_hit.emit()
		# for player health beeping effect
		player.health_beeping.emit()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group('Explosion'):
		boulder_is_hit = true
		hurt.play()
		queue_free()
