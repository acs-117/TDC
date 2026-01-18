extends Area2D


@onready var particles = $CPUParticles2D
@export var grav_x = 0
@export var grav_y = -200
var player : CharacterBody2D = null


func _ready():
	player = get_tree().root.get_node("SpaceShip/Player")
	#u will see the change when u run the game not in the editor
	particles.gravity.x = grav_x
	particles.gravity.y = grav_y
	
func _process(delta: float) -> void:
	pass
	#print(particles.emitting)


func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		if particles.emitting:
			player.hp = 0


func _on_mass_cube_box_activated() -> void:
	particles.emitting = false


func _on_mass_cube_box_deactivated() -> void:
	particles.emitting = true
