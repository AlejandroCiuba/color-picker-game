class_name DialogServer
extends Node

signal text_fetched(text: Array)

var callback_format: Dictionary = {
	"callback": "",
	"args": [],
}

var dialog_id: String = ""
var current_line: int = 0


func next_line() -> void:
	if current_line < DialogManager.LINES_OF_DIALOG:
		DialogManager.line(current_line)

## Perform the callbacks, then display text
func _on_dialog_triggered(dialog: Dialog) -> void:

	current_line += 1
	if dialog.dialog_id != dialog_id:
		return

	for callback in dialog.callbacks:
		callback.call()

	text_fetched.emit(dialog.text)


func _ready() -> void:
	DialogManager.connect_dialog(self)
