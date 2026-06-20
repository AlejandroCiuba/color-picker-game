class_name ColorOverlay
extends CanvasLayer

signal color_selected(color: Color)
signal color_changed(color: Color)


func tween_color_picker_appear() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(%ColorControl, "offset_transform_position:x", 0.0, 0.75).from_current()
	await tween.finished


func tween_color_picker_active() -> void:
	%ColorControl.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED


func tween_color_picker_inactive() -> void:
	%ColorControl.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED


func tween_select_button_appear() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(%SelectColor, "offset_transform_position:y", 0.0, 0.75).from_current()
	await tween.finished


func _on_select_color_pressed() -> void:
	color_selected.emit(%ColorPicker.color)


func _on_color_picker_color_changed(color: Color) -> void:
	color_changed.emit(color)


func _ready() -> void:
	tween_color_picker_inactive()
	%ColorControl.offset_transform_enabled = true
	%ColorControl.offset_transform_position.x = 1000.0
	%SelectColor.offset_transform_enabled = true
	%SelectColor.offset_transform_position.y = 1000.0
