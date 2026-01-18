extends Node2D

@onready var player_wheezing: AudioStreamPlayer = $PlayerWheeze
@onready var player_hurt: AudioStreamPlayer = $PlayerHurt
@onready var explosion: AudioStreamPlayer = $Explosion
@onready var l_ammo: AudioStreamPlayer = $LAmmo
@onready var h_ammo: AudioStreamPlayer = $HAmmo
@onready var p_ammo: AudioStreamPlayer = $PAmmo
@onready var click: AudioStreamPlayer = $Click
@onready var s_click: AudioStreamPlayer = $SClick
@onready var ring: AudioStreamPlayer = $Ring
@onready var thud: AudioStreamPlayer = $Thud
@onready var reactor: AudioStreamPlayer = $Reactor



func _ready():
	Singleton.player_hit.connect(_on_player_hit)
	Singleton.player_wheeze.connect(_on_player_wheeze)
	Singleton.weapon_switched.connect(_on_weapon_switched)
	Singleton.suit_up.connect(_on_suited_up)
	Singleton.ring_fx.connect(_on_ring)
	Singleton.thud_fx.connect(_on_thud)
	Singleton.grenade_explode.connect(_on_grenade_exploded)
	Singleton.reactor.connect(_on_reactor)
	

func _on_weapon_switched():
	click.play()
func _on_suited_up():
	s_click.play()
func _on_ring():
	ring.play()
func _on_thud():
	thud.play()
func _on_reactor():
	reactor.play()


func _on_player_hit():
	player_hurt.play()
func _on_player_wheeze():
	player_wheezing.play()


func _on_grenade_greande_exploded() -> void:
	explosion.play()
func _on_grenade_exploded():
	explosion.play()

func _on_light_l_sound() -> void:
	l_ammo.play()
func _on_heavy_h_sound() -> void:
	h_ammo.play()
func _on_plasma_p_sound() -> void:
	p_ammo.play()
