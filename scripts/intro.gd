extends Control


var timer = 0


func _process(delta: float) -> void:
	timer += 1 * delta
	
	if Input.is_action_just_pressed("jump"):
		if ResourceLoader.exists("res://scenes/space_ship.tscn"):
			get_tree().change_scene_to_file("res://scenes/space_ship.tscn")
		else:
			push_error("Scene not found in export!")

	elif timer > 87:
		get_tree().change_scene_to_file("res://scenes/space_ship.tscn")
