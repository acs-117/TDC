extends Area2D

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var background: AudioStreamPlayer = $"../../../Background"

@export var music_piece: AudioStream
var has_not_played: bool = true
@export var volume = 0
signal playing_finished


func _ready() -> void:
	audio.stream = music_piece
	audio.volume_db = volume


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') and has_not_played and Singleton.music_playing == false:
		audio.play()
		has_not_played = false
		Singleton.music_playing = true
		


func _on_audio_stream_player_finished() -> void:
	playing_finished.emit()
