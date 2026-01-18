extends Control
@onready var spaceship: AnimatedSprite2D = $Spaceship
@onready var ui_sound: AudioStreamPlayer = $UISound
@onready var bcontinue: Button = $MarginContainer/VBoxContainer/Continue
var save_file = SaveFile.new()

var temp_player_pos = Vector2 (444,-363)



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if save_file:
		bcontinue.visible = true


func _process(delta: float) -> void:
	spaceship.position.x += 0.5
	if spaceship.position.x >= 3456:
		spaceship.position.x = -1332


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/space_ship.tscn")

func _on_new_game_pressed() -> void:
	new_game_start()
	get_tree().change_scene_to_file("res://scenes/background/intro.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/background/options_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_play_mouse_entered() -> void:
	ui_sound.play()


func _on_quit_mouse_entered() -> void:
	ui_sound.play()


func new_game_start():
	if save_file :  # Check both exist
		# new game values
		save_file.player_pos = temp_player_pos
		save_file.body_path = "res://assets/sprites/player/human_body.png"
		save_file.head_path = "res://assets/sprites/player/human_head.png"
		var save_path = "user://savegame.tres"  # Better than C: path
		var error = ResourceSaver.save(save_file, save_path)
		if error == OK:
			print("New Game initiated: ", save_path)
		else:
			push_error("Failed to start: ", error)
