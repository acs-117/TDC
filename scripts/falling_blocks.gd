extends CharacterBody2D


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_dropped: bool  = false
var timer = 30

func _physics_process(delta: float) -> void:
	
	if is_dropped:
		timer -= 1
		if timer < 0 and timer > -600:
			position.y += 3
		elif timer <- 600:
			queue_free()
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		is_dropped = true
	
