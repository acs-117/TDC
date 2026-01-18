extends CanvasLayer

@onready var tex: TextureRect = $TextureRect
@export var fade_speed: float = 0.5 # Adjust speed (1.0 = fast, 0.1 = slow)

func _ready():
	tex.self_modulate.a = 1.0  # Start fully opaque

func _process(delta):
	
	if tex.self_modulate.a > 0.0:
		tex.self_modulate.a -= fade_speed * delta  # Decrease opacity
	elif tex.self_modulate.a < 0.0:
		queue_free()
