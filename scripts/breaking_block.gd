extends RigidBody2D

@export var is_static: bool = true

func _ready():
	self.freeze = is_static
	
	# used to set collision layer (it wont show in print)
	# syntax => <1 or 0 (true or false)> << index of collision (layer 1 starts with 0)
	# below both layer 1 and layer 3 are enabled 
	if is_static:
		self.collision_layer =  1 << 0 | 1 << 1 | 1 << 2 | 1 << 3
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('Explosion'):
		queue_free()
	

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("projectile"):
		queue_free()
