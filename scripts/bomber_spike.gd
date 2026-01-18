extends CharacterBody2D


var direction: int = 1  # 1 for right, -1 for left
var speed: float = 300.0
@export var bomber_damage = 10
@export var timer = 30
var player : CharacterBody2D = null

func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")


func _physics_process(delta):
	position.x += speed * direction * delta
	deletion()
	move_and_collide(velocity)
	# Optional: delete when off-screen
	#if not get_viewport_rect().has_point(global_position):
		#queue_free()


func _on_hit_zone_body_entered(body: Node2D) -> void:
	
	if body.is_in_group('Player'):
		player.hp -= bomber_damage

func deletion():
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
	timer -= 1
	if timer <= 0:
		queue_free()
