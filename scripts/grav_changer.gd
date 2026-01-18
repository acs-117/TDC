extends Node2D

@onready var grav_on: CollisionShape2D = $GravOn
@onready var grav_off: CollisionShape2D = $GravOff
var player_inside: bool = false
var player : CharacterBody2D = null


func _ready() -> void:
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")
	
	
func _process(delta: float) -> void:
	
	if player_inside and player.player_cam.zoom.x > 3 and player.player_cam.zoom.y > 3:
		player.player_cam.zoom.x -= 0.005
		player.player_cam.zoom.y -= 0.005
	

func _on_grav_on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		player_inside = true
		player.gravity = 10
		
		# Mute a bus by name
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)


func _on_grav_off_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		player_inside = false
		player.gravity = 20
		player.player_cam.zoom = Vector2(4,4)

		# Unmute the same bus
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
