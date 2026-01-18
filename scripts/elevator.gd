extends CharacterBody2D


@export var elevation_speed: int = 2
@export var max_height: int
@export var min_height: int
var trigger_elevator: bool = false
var is_interactable: bool =false
@export var is_above: bool = false

@onready var elevator = $"."
@onready var switch_light = $PointLight2D
@onready var elevator_sound = $ElevatorSound
@onready var elevator_start = $ElevatorStart
var player = null

func _ready() -> void:
	player = get_tree().root.get_node("SpaceShip/Player")

func _physics_process(_delta):
	#elevator movement 
	#print(position.y)
	if is_interactable and Input.is_action_just_pressed("interact"):
		trigger_elevator = true
		elevator_sound.play()
		elevator_start.play()

	if trigger_elevator :
		switch_light.color = Color(0 , 1 , 0)
		#going up
		if is_above == false and position.y > max_height:
			position.y -= elevation_speed
			
		elif position.y == max_height:
			is_above = true
			trigger_elevator = false
			switch_light.color = Color(1 , 0 , 0)
			elevator_sound.stop()
		
		#going down
		if is_above == true and position.y < min_height:
			position.y += elevation_speed
			
		elif position.y == min_height:
			is_above = false
			trigger_elevator = false
			switch_light.color = Color(1 , 0 , 0)
			elevator_sound.stop()
	
	



func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		is_interactable = true
		#if (is_above == false and position.y == min_height) or (is_above == true and position.y == max_height):
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		is_interactable = false
