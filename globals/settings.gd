extends Node

var on_next_press: String = "Dump Text"
var text_speed: float = 0.01
var autoplay_dialog: bool = false
var sound_muted: bool = false:
	set(value):
		var ind: int = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(ind, value)
