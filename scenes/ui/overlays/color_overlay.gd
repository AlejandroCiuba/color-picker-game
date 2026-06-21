class_name ColorOverlay
extends Control

signal color_selected(color: Color)
signal color_changed(color: Color)


func tween_color_picker_active() -> void:
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED


func tween_color_picker_inactive() -> void:
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED


func tween_select_button_appear() -> void:
	await %SelectTweenLibrary.appear()


func _on_select_color_pressed() -> void:
	color_selected.emit(%ColorPicker.color)


func _on_color_picker_color_changed(color: Color) -> void:
	color_changed.emit(color)


func _ready() -> void:
	tween_color_picker_inactive()
