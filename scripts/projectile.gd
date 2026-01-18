extends CharacterBody2D

var player: CharacterBody2D = null
#var velocity: Vector2

func _ready():
	player = get_tree().root.get_node("SpaceShip/Player")
	
	# Move in the direction the bullet is rotated
	velocity = Vector2.RIGHT.rotated(rotation) * player.active_weapon.bullet_speed

func _physics_process(delta: float) -> void:
	#print("Bullet rotation (deg): ", rad_to_deg(global_rotation))
	#print(player.active_weapon.shoot_direction)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
	elif global_position.distance_to(player.global_position) > player.active_weapon.fire_range:
		queue_free()
