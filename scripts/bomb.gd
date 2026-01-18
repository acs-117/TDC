extends RigidBody2D

@export var bomb_damage = 20
@export var speed := 200.0
@export var explode_timer = 70
var timer = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion_area: CollisionShape2D = $ExplosionNodes/ExplosionArea
@onready var explosion_light: PointLight2D = $ExplosionNodes/ExplosionLight
@onready var animated_sprite_2d: AnimatedSprite2D = $ExplosionNodes/AnimatedSprite2D
var player = null

func _ready():
	player = get_tree().root.get_node("SpaceShip/Player")
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed
	angular_velocity = 0.0  # optional spin
	explosion_area.disabled = true
	explosion_light.visible = false

func _process(delta: float) -> void:
	timer += 1
	if timer == explode_timer:
		
		explosion_area.disabled = false
		explosion_light.visible = true
		sprite_2d.visible = false
		animated_sprite_2d.play()
		Singleton.grenade_explode.emit()
		
		player.max_shake = 3.0
		player.trigger_shake()
		
		linear_velocity = Vector2.ZERO
		
	if timer >= explode_timer + 60:
		queue_free()


func _on_explosion_nodes_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		player.hp -= bomb_damage
		Singleton.player_hit.emit()

		# for player health beeping effect
		player.health_beeping.emit()
