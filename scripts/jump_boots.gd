extends Area2D

@export var wall_jump: bool = false
@export var double_jump: bool = false
var player : CharacterBody2D = null
@onready var sprite: Sprite2D = $Sprite2D
var player_entered
func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	if wall_jump:
		sprite.texture = load("res://assets/sprites/scenery/items/wall_jump_gear.png")
	elif double_jump:
		sprite.texture = load("res://assets/sprites/scenery/items/double_jump_gear.png")

func _process(delta: float) -> void:
	
	if player_entered and Input.is_action_just_pressed("interact"):
		if wall_jump:
				player.ray_cast_2d.enabled = true
				
		elif double_jump:
			player.enable_double_jump = 1
		Singleton.suit_up.emit()
		queue_free()


func _on_body_entered(body):
	if body.is_in_group('Player'):
		if wall_jump:
			player_entered = true
		elif double_jump:
			player_entered = true



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		player_entered = false
