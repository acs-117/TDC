extends Label

@export var visibility_timer : float = 0.0
@export var invisibility_timer : float = 0.0
@export var fade_speed: float = 0.2
@export var typing_speed: float = 0.001
var timer = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 1 * delta
	if timer > invisibility_timer and self_modulate.a > 0.0:
		self_modulate.a -= fade_speed * delta  # Increase opacity
	
	if timer > visibility_timer and visible_ratio <= 1:
		visible_ratio += typing_speed * delta
	
