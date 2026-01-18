extends Node2D

@onready var interaction_label: Label = $"../../UI/HUD/InteractionLabel"
@onready var interaction_label_2: Label = $"../../UI/HUD/InteractionLabel2"
var player = null


func _ready():
	# Find the player node
	interaction_label.visible = false
	interaction_label_2.visible = false
