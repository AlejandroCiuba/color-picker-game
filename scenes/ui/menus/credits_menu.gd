extends Menu

@export_category("Tween Delays")
@export var delay_time_start: float = 1E-2

@export_category("Menus")
@export var start_menu: Menu = null


func _on_button_pressed(_button: BaseButton, menu: String) -> void:

	match menu:
		"start":
			await _exit_tween()
			game_started.emit()
		"main":
			await _exit_tween()
			main_opened.emit()

	hide()


func _entrance_tween() -> void:

	super()
	show()

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:x", 0.0, 0.75 + (i * delay_time_start)).from_current()

	await tween.finished


func _exit_tween() -> void:

	super()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:x", 1000.0, 0.75 + (i * delay_time_start)).from_current()

	await tween.finished


func _ready() -> void:

	super()

	hide()
	for item in items:
		item.offset_transform_position.x = 1000.0

	if start_menu == null:
		return
	start_menu.credits_opened.connect(_entrance_tween)
