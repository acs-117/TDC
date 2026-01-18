extends Area2D

@onready var suit: Sprite2D = $Sprite2D

@export var hazmat_suit: bool = false
@export var space_armor: bool = false
signal hazmat_suit_equiped
signal space_armor_equipped
var player_entered = false


func _process(delta: float) -> void:
	
	if player_entered and Input.is_action_pressed("interact"):
		if hazmat_suit:
			hazmat_suit_equiped.emit()
			Singleton.suit_up.emit()
		elif space_armor:
			space_armor_equipped.emit()
			Singleton.suit_up.emit()

func _ready() -> void:
	if hazmat_suit:
		suit.texture = load("res://assets/sprites/scenery/items/hazmat_suit.png")
	elif space_armor:
		suit.texture = load("res://assets/sprites/scenery/items/space_suit.png")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_entered = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_entered = false
