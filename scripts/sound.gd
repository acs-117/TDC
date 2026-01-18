extends Node2D


@onready var player: CharacterBody2D = $"../../Player"
@onready var health_beep: AudioStreamPlayer = $Health_Beep
@onready var background: AudioStreamPlayer = $Background
var fading_away : bool

signal health_low

func _ready() -> void:
	background.stream.loop = true
	background.volume_db = -40
	fading_away = false


func _process(delta: float) -> void:
	
	#print(player.hp)
	if fading_away and background.volume_db >= -40:
		background.volume_db -= 0.05
	
	elif fading_away == false and background.volume_db <= -15:
		background.volume_db += 0.05
	



func _on_music_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fading_away = true # fade out bg

func _on_music_area_playing_finished() -> void:
	fading_away = false # to start fading in bg
	Singleton.music_playing = false



func heart_beat():
	pass
	#if player.hp <= 50:
	#elif player.hp > 50:
		#low_health.stop()
		
	


func _on_player_health_beeping() -> void:
	if player.hp <= 30:
		health_beep.play()
	elif player.hp > 30:
		health_beep.stop()
