extends Control


@export var screen_offset: Vector2 = Vector2.ZERO
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://shaders/space.gdshader")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	if camera:
		global_position = camera.get_screen_center_position() + screen_offset
