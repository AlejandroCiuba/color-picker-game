extends CanvasLayer

signal game_started()

@onready var title: RichTextLabel = %Title
@onready var start_button: AnimatedButton = %StartButton
@onready var options_button: AnimatedButton = %OptionsButton
@onready var credits_button: AnimatedButton = %CreditsButton


func _start_tween() -> void:

	var items: Array[Control] = [title, start_button, options_button, credits_button]

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		tween.tween_property(items[i], "position:y", 1000.0, 0.75 + (i * 1E-2)).from_current()

	await tween.finished


func _ready_tween() -> void:

	var items: Array[Control] = [title, start_button, options_button, credits_button]

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	for i in range(items.size()):
		items[i].position.x = 1000.0
		tween.tween_property(items[i], "position:x", 0.0, 0.75 + (i * 1E-1)).from_current()



func _on_start_button_pressed() -> void:
	await _start_tween()
	hide()
	game_started.emit()


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _ready() -> void:
	_ready_tween()
