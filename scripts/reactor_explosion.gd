extends Node2D

var player_entered = false
var button_pressed = false
var timer = 0
@export var end_timer: int = 10
@onready var world_environment: WorldEnvironment = $"../../Lights/WorldEnvironment"
var env = null

func _ready() -> void:
	env = world_environment.environment


func _process(delta: float) -> void:
	if player_entered:
		if Input.is_action_just_pressed("interact"):
			button_pressed = true
			Singleton.reactor.emit()
	if button_pressed:
		timer += delta
		env.glow_intensity += 0.005

		if timer >= end_timer:
			get_tree().change_scene_to_file("res://scenes/background/ending.tscn")
		



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_entered = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_entered = false
