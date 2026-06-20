extends Menu


@export_category("Tween Delays")
@export var delay_time_start: float = 1E-2


@export_category("Menus")
@export var start_menu: Menu = null


func _entrance_tween() -> void:

	super()
	show()

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:y", 0.0, 0.75 + (i * delay_time_start)).from_current()

	await tween.finished


func _exit_tween() -> void:

	super()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:y", 1000.0, 0.75 + (i * delay_time_start)).from_current()

	await tween.finished


func _on_button_pressed(_button: BaseButton, menu: String) -> void:

	match menu:
		"start":
			await _exit_tween()
			game_started.emit()
		"main":
			await _exit_tween()
			main_opened.emit()

	hide()


func _on_text_speed_value_changed(value: float) -> void:
	Settings.text_speed = value


func _on_autoplay_toggled(toggled_on: bool) -> void:
	Settings.autoplay_dialog = toggled_on


func _on_muted_toggled(toggled_on: bool) -> void:
	Settings.sound_muted = toggled_on


func _on_next_options_item_selected(index: int, source: OptionButton) -> void:
	Settings.on_next_press = source.get_item_text(index)


func _ready() -> void:

	super()

	%TextSpeed.value = Settings.text_speed
	%Autoplay.set_pressed_no_signal(Settings.autoplay_dialog)
	Settings.on_next_press = %NextOptions.get_item_text(%NextOptions.selected)

	hide()
	for item in items:
		item.offset_transform_position.y = 1000.0

	if start_menu == null:
		return
	start_menu.options_opened.connect(_entrance_tween)
