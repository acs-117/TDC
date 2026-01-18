extends Control

@onready var death: Label = $Death
@onready var v_box: VBoxContainer = $VBoxContainer
@export var fade_speed: float = 0.2
@onready var ui_sound: AudioStreamPlayer2D = $UISound


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	death.self_modulate.a = 0.0  # Start fully transparent
	v_box.modulate.a = 0.0

func _process(delta):
	if death.self_modulate.a < 1.0:
		death.self_modulate.a += fade_speed * delta  # Increase opacity
	if v_box.modulate.a < 1.0 and death.self_modulate.a >0.5:
		v_box.modulate.a += fade_speed * delta  # Increase opacity
	


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/space_ship.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_again_mouse_entered() -> void:
	ui_sound.play()
	
func _on_quit_mouse_entered() -> void:
	ui_sound.play()
