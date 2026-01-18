class_name SaveFile extends Resource


@export var player_pos : Vector2
@export var player_hp : int

@export var player_weapon1 = null
@export var player_weapon2 = null
@export var light_ammo : int
@export var heavy_ammo : int
@export var plasma_ammo : int

@export var head_path : String
@export var body_path : String

@export var wall_jump : bool
@export var double_jump : int

@export var sdoor2 : bool
@export var sdoor4 : bool

func _init() -> void:
	player_pos = Vector2(795, -1030)
	player_hp = 100
	#body_path = "res://assets/sprites/human_body"
