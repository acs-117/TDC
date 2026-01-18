extends Node2D

@onready var player: CharacterBody2D = $".."
@onready var front_arm: AnimatedSprite2D = $FrontArm
@onready var back_arm: AnimatedSprite2D = $BackArm
@onready var weapon_holder: Node2D = $WeaponHolder
@onready var legs: AnimatedSprite2D = $Legs

var can_slide = 1
var is_sliding = false
var slide_timer = 60
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	

	if player.active_weapon != null:

		front_arm.look_at(get_global_mouse_position())
		back_arm.look_at(get_global_mouse_position())
		weapon_holder.look_at(get_global_mouse_position())
		
		if player.is_player_right:
			front_arm.rotation += deg_to_rad(0)
			back_arm.rotation += deg_to_rad(0)
			weapon_holder.rotation += deg_to_rad(0)
		else:
			front_arm.rotation += deg_to_rad(180)
			back_arm.rotation += deg_to_rad(180)
			weapon_holder.rotation += deg_to_rad(180)
			
	else:
		front_arm.rotation = deg_to_rad(0)
		back_arm.rotation = deg_to_rad(0)
		weapon_holder.rotation += deg_to_rad(0)


func sliding(delta):
	#print(is_sliding)
	
	#print(player.velocity.x)

	if Input.is_action_just_pressed("slide") and can_slide and player.is_on_floor():
		can_slide = 0
		player.velocity.x += 200 * sign(player.velocity.x)
		is_sliding = true
		legs.play("slide")
		player.slide_crouch_changes()
		
	
	
	if abs(player.velocity.x) > player.speed:
		player.velocity.x -= 6 * sign(player.velocity.x)
	else:
		is_sliding = false
		can_slide = 1
	
		
