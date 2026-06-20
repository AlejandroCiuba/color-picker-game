extends Menu

@export_category("Tween Delays")
@export var delay_time_ready: float = 1E-2
@export var delay_time_start: float = 1E-2
@export var delay_time_options: float = 1E-2
@export var delay_time_credits: float = 1E-2


@export_category("Menus")
@export var options_menu: Menu = null
@export var credits_menu: Menu = null


@onready var title: RichTextLabel = %Title
@onready var start_button: AnimatedButton = %StartButton
@onready var options_button: AnimatedButton = %OptionsButton
@onready var credits_button: AnimatedButton = %CreditsButton


func _exit_tween() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:y", 1000.0, 0.75 + (i * delay_time_start)).from_current()

	await tween.finished


func _options_tween() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:y", -1000.0, 0.75 + (i * delay_time_options)).from_current()

	await tween.finished


func _credits_tween() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:x", -1000.0, 0.75 + (i * delay_time_credits)).from_current()

	await tween.finished


func _entrance_tween() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:x", 0.0, 0.75 + (i * delay_time_ready)).from(1000.0)


func _entrance_tween_options() -> void:

	show()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:y", 0.0, 0.75 + (i * delay_time_options)).from_current()

	await tween.finished


func _entrance_tween_credits() -> void:

	show()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "offset_transform_position:x", 0.0, 0.75 + (i * delay_time_credits)).from_current()

	await tween.finished



func _on_button_pressed(_button: BaseButton, menu: String) -> void:

	match menu:
		"start":
			await _exit_tween()
			game_started.emit()
		"options":
			await _options_tween()
			options_opened.emit()
		"credits":
			await _credits_tween()
			credits_opened.emit()
	hide()


func _ready() -> void:
	super()
	start_button.disabled = false
	options_button.disabled = false
	credits_button.disabled = false
	_entrance_tween()
	if options_menu != null:
		options_menu.main_opened.connect(_entrance_tween_options)
	if credits_menu != null:
		credits_menu.main_opened.connect(_entrance_tween_credits)
