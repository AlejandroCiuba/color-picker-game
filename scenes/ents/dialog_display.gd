class_name DialogDisplay
extends Node

@export var dialog_box: DialogBox = null
@export var next_button: BaseButton = null

@onready var dialog_id: String = dialog_box.dialog_id
@onready var current_line: int = 0


## Perform the callbacks, then display text
func _on_dialog_triggered(dialog: Dialog) -> void:

	current_line += 1
	if dialog.dialog_id != dialog_id:
		return

	for callback in dialog.callbacks:
		callback.call()

	dialog_box.write(dialog.text)


func _on_next_button_pressed() -> void:
	DialogManager.line(current_line)


func _ready() -> void:
	DialogManager.connect_dialog(self)
	next_button.pressed.connect(_on_next_button_pressed)
