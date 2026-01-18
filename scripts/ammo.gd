extends Area2D

var player : CharacterBody2D = null
@export var ammo_refill = 10
@onready var ammo_sprite: Sprite2D = $AmmoSprite
signal l_sound
signal h_sound
signal p_sound


func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	if self.is_in_group('light ammo'):
		ammo_sprite.texture = load('res://assets/sprites/scenery/items/light_ammo.png')
	if self.is_in_group('heavy ammo'):
		ammo_sprite.texture = load('res://assets/sprites/scenery/items/heavy_ammo.png')
	if self.is_in_group('plasma ammo'):
		ammo_sprite.texture = load('res://assets/sprites/scenery/items/plasma_ammo.png')
	

	
func _on_body_entered(body):
	if body.is_in_group('Player'):
		
		if self.is_in_group('light ammo'):
			player.light_ammo_count += ammo_refill
			player.light_ammo_label.text = str(player.light_ammo_count)
			l_sound.emit()
		elif self.is_in_group('heavy ammo'):
			player.heavy_ammo_count += ammo_refill
			player.heavy_ammo_label.text = str(player.heavy_ammo_count)
			h_sound.emit()
		elif self.is_in_group('plasma ammo'):
			player.plasma_ammo_count += ammo_refill
			player.plasma_ammo_label.text = str(player.plasma_ammo_count)
			p_sound.emit()
		queue_free()
