extends Area2D

signal target_hit

func _process(delta: float) -> void:
	pass


func _on_body_entered(body):
	if body.is_in_group("projectile"):
		print('hit')
		target_hit.emit()
