extends Area2D

signal box_activated
signal box_deactivated

@export var toxic_pipe_mode: bool = false
@export var sliding_door_mode: bool = false
@onready var toxic_pipe_1: Area2D = $"../../ToxicPipes/ToxicPipe1"

@onready var switch_light = $PointLight2D
var is_activated = 0


	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("box"):
		is_activated = 1
		box_activated.emit()
		switch_light.color = Color(0 , 1 , 0)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("box"):
		is_activated = 0
		box_deactivated.emit()
		switch_light.color = Color(1 , 0 , 0)
	
	
