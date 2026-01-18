extends Area2D  # or Area3D

@export_multiline var dialog_text := "Computer message goes here"
var player_entered: bool = false


func _process(delta: float) -> void:

	if player_entered and Input.is_action_pressed("interact"):
		get_tree().call_group("computer_ui", "show_message", dialog_text)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_entered = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_entered = false
		# amazing function call_group(<group name> , <function> , <arguments>)
		get_tree().call_group("computer_ui", "hide_message")
