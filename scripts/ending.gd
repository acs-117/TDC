extends Control


var timer = 0


func _process(delta: float) -> void:
	timer += 1 * delta
	
	if timer > 78.27:
		get_tree().change_scene_to_file("res://scenes/background/main_menu.tscn")
