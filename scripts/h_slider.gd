extends HSlider

@export var bus_name: String
var bus_index: int



func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value = AudioServer.get_bus_volume_db(bus_index)
	value_changed.connect(_on_volume_changed)


func _on_volume_changed(value: float) ->void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
