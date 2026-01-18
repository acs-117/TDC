extends Area2D

var save_file = SaveFile.new()
var player : CharacterBody2D = null

func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")



func _on_body_entered(body: Node2D) -> void:
	if Input.is_action_pressed("crouch"):
		if body.is_in_group("Player"):
			if save_file and player:  # Check both exist
				
				save_file.player_pos = player.position  # Must be Vector2
				save_file.player_hp = player.hp
				save_file.light_ammo = player.light_ammo_count
				print('player health is: ',player.hp)
				print('player position: ',player.position)
				print('light ammo: ',player.light_ammo_count)

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
