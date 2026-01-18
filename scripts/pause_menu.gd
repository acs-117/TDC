extends Control

@onready var container: VBoxContainer = $CanvasLayer/VBoxContainer


@onready var canvas_layer: CanvasLayer = $CanvasLayer
@export var screen_offset: Vector2 = Vector2.ZERO
var paused = false
@onready var world_environment: WorldEnvironment = $"../../Lights/WorldEnvironment"
var env = null


func _ready():
	visible = false
	container.visible = false
	env = world_environment.environment

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	if camera:
		global_position = camera.get_screen_center_position() + screen_offset
	if Input.is_action_just_pressed("Pause"):
		if not paused:
			get_tree().call_group("computer_ui", "hide_message")
			pause()
		else:
			resume()


func pause():
	
	Singleton.ui_active = true
	container.visible = true
	Engine.time_scale = 0
	visible = true
	paused = true
	env.adjustment_saturation = 0.5
	Singleton.ring_fx.emit()


func resume():
	
	Singleton.ui_active = false
	container.visible = false
	Engine.time_scale = 1
	visible = false
	paused = false
	env.adjustment_saturation = 1
	


func _on_resume_pressed() -> void:
	resume()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/background/main_menu.tscn")
	Engine.time_scale = 1
	
