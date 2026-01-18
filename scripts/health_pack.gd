extends Area2D


var player : CharacterBody2D = null
var is_healable: bool = false

@export var health_reserve: float = 40.0
@export var health_per_sec: float = 0.25

@onready var point_light_2d = $PointLight2D
@onready var health_bar = $"../../../UI/HUD/HealthBar"
@onready var healing = $Healing



func _ready():
	# Find the player node
	player = get_tree().root.get_node("SpaceShip/Player")

func _process(_delta):
	#print(is_healable)
	if is_healable == true:
		#healing.play()
		
		if player.hp < 100 and health_reserve != 0:
			player.health_beeping.emit()
			player.hp += health_per_sec
			health_reserve -= health_per_sec
			health_bar.value = player.hp
			#print(health_reserve)
	if health_reserve == 0:
		point_light_2d.enabled = false
		healing.stop()





func _on_body_entered(body):
	if body.is_in_group("Player"):
		is_healable = true
		if player.hp < 100 and health_reserve != 0:
			healing.play()
		
		#print(player.hp)
		


func _on_body_exited(body):
	if body.is_in_group("Player"):
		player.health_beeping.emit()
		is_healable = false
		healing.stop()
