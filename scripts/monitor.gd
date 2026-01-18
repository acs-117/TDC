extends Control

var save_file = SaveFile.new()
var player : CharacterBody2D = null
var sd2 = null
var sd4 = null

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label
@export var screen_offset: Vector2 = Vector2.ZERO

@export var bus_name: String
@export var bus_indext: int

func _ready():

	player = get_tree().root.get_node("SpaceShip/Player")
	sd2 = get_tree().root.get_node("SpaceShip/Prefabs/SlidingDoors/SlidingDoor2")
	sd4 = get_tree().root.get_node("SpaceShip/Prefabs/SlidingDoors/SlidingDoor4")
	
	add_to_group("computer_ui")
	hide()
	canvas_layer.visible = false
	label.visible_ratio = 0


func _process(delta):
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		global_position = camera.get_screen_center_position() + screen_offset

	if canvas_layer.visible and label.visible_ratio != 1:
		label.visible_ratio += 0.003
	elif not canvas_layer.visible:
		label.visible_ratio = 0

func show_message(text: String):
	label.text = text
	canvas_layer.visible = true
	show()
	Singleton.ring_fx.emit()
	Singleton.ui_active = true


func hide_message():
	hide()
	canvas_layer.visible = false
	Singleton.ui_active = false


func _on_save_pressed() -> void:
	
	if save_file and player:  # Check both exist
		Singleton.thud_fx.emit()
		save_file.player_pos = player.position  # Must be Vector2
		save_file.player_hp = player.hp
		
		save_file.light_ammo = player.light_ammo_count
		save_file.heavy_ammo = player.heavy_ammo_count
		save_file.plasma_ammo = player.plasma_ammo_count
		
		save_file.head_path = player.head.texture.resource_path
		save_file.body_path = player.body.texture.resource_path
		
		save_file.wall_jump = player.ray_cast_2d.enabled
		save_file.double_jump = player.enable_double_jump
		
		save_file.sdoor2 = sd2.go_up
		save_file.sdoor4 = sd4.go_up
		print(sd2.go_up)

		if player.active_weapon != null:
			save_file.player_weapon1 = player.active_weapon.name
			print(save_file.player_weapon1)
		if player.holstered_weapon != null:
			save_file.player_weapon2 = player.holstered_weapon.name
			print(save_file.player_weapon2)
		
		var save_path = "user://savegame.tres"  # Better than C: path
		var error = ResourceSaver.save(save_file, save_path)
		if error == OK:
			print("Saved successfully to: ", save_path)
		else:
			push_error("Failed to save: ", error)


func _on_close_pressed() -> void:
	hide_message()
