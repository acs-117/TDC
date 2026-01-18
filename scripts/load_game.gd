extends Node2D


var save_file = SaveFile.new()
@onready var player: CharacterBody2D = $"../../Player"
@onready var light_ammo_label: Label = $"../../UI/HUD/LightAmmoLabel"
@onready var heavy_ammo_label: Label = $"../../UI/HUD/HeavyAmmoLabel"
@onready var plasma_ammo_label: Label = $"../../UI/HUD/PlasmaAmmoLabel"
@onready var sdoor_2: CharacterBody2D = $"../../Prefabs/SlidingDoors/SlidingDoor2"
@onready var sdoor_4: CharacterBody2D = $"../../Prefabs/SlidingDoors/SlidingDoor4"


#weapons


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var save_path = "user://savegame.tres"
	
	if ResourceLoader.exists(save_path):
			save_file = ResourceLoader.load(save_path)
			
			print("Loaded successfully from: ", save_path)
			print('health: ',save_file.player_pos)
			print('position: ',save_file.player_hp)
			print(save_file.player_weapon1)
			print(save_file.player_weapon2)
			print('light ammo: ', save_file.light_ammo)
			print('heavy ammo: ', save_file.heavy_ammo)
			print('plasma ammo: ', save_file.plasma_ammo)
			
			player.hp = save_file.player_hp
			player.position = save_file.player_pos
			player.light_ammo_count = save_file.light_ammo
			player.heavy_ammo_count = save_file.heavy_ammo
			player.plasma_ammo_count = save_file.plasma_ammo
			
			player.head.texture = load(save_file.head_path)
			player.body.texture = load(save_file.body_path)
			
			player.ray_cast_2d.enabled = save_file.wall_jump
			player.enable_double_jump = save_file.double_jump
			
			light_ammo_label.text = str(player.light_ammo_count)
			heavy_ammo_label.text = str(player.heavy_ammo_count)
			plasma_ammo_label.text = str(player.plasma_ammo_count)
			
			sdoor_2.go_up = save_file.sdoor2
			sdoor_4.go_up = save_file.sdoor4
			weapon_equip()
			
			player.health_beeping.emit()

func weapon_equip():
	#if weapon == null:
		#print("Cannot equip - weapon is null")
		#return
	
	if save_file.player_weapon1 != null:
		var weapon = get_tree().current_scene.find_child(save_file.player_weapon1, true, false)
		if weapon:
			weapon.position = player.position
			print("weapon1: ",weapon)


	if save_file.player_weapon2 != null:
		var weapon = get_tree().current_scene.find_child(save_file.player_weapon2, true, false)
		if weapon:
			weapon.position = player.position
			weapon.position.y -= 5
			print("weapon2: ",weapon)

	
