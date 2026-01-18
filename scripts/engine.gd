extends Sprite2D


@onready var engine_sound = $EngineSound


func _ready():
	engine_sound.stream.loop = true
	engine_sound.play()
