extends PointLight2D

@export var muzzle_cooldown: int = 2


func _process(_delta):
	muzzle_cooldown -= 1
	if muzzle_cooldown == 0:
		queue_free()
