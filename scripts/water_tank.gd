extends Node2D

@onready var bubbles = $Bubbles

func _ready():
	bubbles.stream.loop = true
	bubbles.play()
