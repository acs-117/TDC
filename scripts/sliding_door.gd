extends CharacterBody2D


@export var door8: bool = false
var decon_smoke : CPUParticles2D = null
var pos_x = 0
var pos_y = 0
var go_up: bool = false



func _process(delta: float) -> void:
	#print(pos_y)
	
	if go_up == true and pos_y >= -50:
		pos_y -= 1
		position.y -= 1
	if go_up == false and pos_y <= 0:
		pos_y += 1
		position.y += 1


func _on_target_target_hit() -> void:
	go_up = true
	Singleton.ring_fx.emit()


func _on_mass_cube_2_box_activated() -> void:
	go_up = true

func _on_mass_cube_2_box_deactivated() -> void:
	go_up = false
	
func _on_mass_cube_3_box_activated() -> void:
	go_up = true


func _on_mass_cube_3_box_deactivated() -> void:
	go_up = false


# decontamination code

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		go_up = true
		decon_smoke = get_tree().root.get_node("SpaceShip/Areas/Decon/DeconSmoke")
		decon_smoke.emitting = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		go_up = false
		decon_smoke = get_tree().root.get_node("SpaceShip/Areas/Decon/DeconSmoke")
		decon_smoke.emitting = false


func _on_mass_cube_4_box_activated() -> void:
	go_up = true
	if door8:
		go_up = false
	


func _on_mass_cube_4_box_deactivated() -> void:
	go_up = false
	if door8:
		go_up = true


func _on_target_2_target_hit() -> void:
	go_up = true
	Singleton.ring_fx.emit()


func _on_target_3_target_hit() -> void:
	go_up = true
	Singleton.ring_fx.emit()
