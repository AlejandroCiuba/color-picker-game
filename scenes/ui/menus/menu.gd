@abstract class_name Menu
extends CanvasLayer

@warning_ignore("unused_signal")
signal game_started()
@warning_ignore("unused_signal")
signal options_opened()
@warning_ignore("unused_signal")
signal credits_opened()
@warning_ignore("unused_signal")
signal main_opened()

@export var control: Control = null
@export var items: Array[Control] = []


@abstract func _on_button_pressed(button: BaseButton, menu: String) -> void


func _entrance_tween() -> void:
	if control != null:
		control.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED


func _exit_tween() -> void:
	if control != null:
		control.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED


func _ready() -> void:
	for item in items:
		item.offset_transform_enabled = true
