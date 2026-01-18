extends Area2D

var is_entered: bool = false
var player = null
@export var lab_area : bool = false
@export var space_area : bool = false

func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_entered and lab_area and not player.body.texture == load("res://assets/sprites/player/hazmat_body.png"):
		player.hp -= 0.2
		
	elif is_entered and space_area and not player.body.texture == load("res://assets/sprites/player/space_body.png"):
		player.hp -= 0.2


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		is_entered = true
	
	if is_entered and lab_area and not player.body.texture == load("res://assets/sprites/player/hazmat_body.png"):
		Singleton.player_wheeze.emit()
	elif is_entered and space_area and not player.body.texture == load("res://assets/sprites/player/space_body.png"):
		Singleton.player_wheeze.emit()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		is_entered = false
