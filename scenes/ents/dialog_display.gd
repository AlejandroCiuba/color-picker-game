class_name DialogDisplay
extends Node

@export var dialog_box: DialogBox = null

@onready var dialog_id: String = dialog_box.dialog_id


## Perform the callbacks, then display text
func _on_dialog_triggered(dialog: Dialog) -> void:

	if dialog.dialog_id != dialog_id:
		return

	for callback in dialog.callbacks:
		callback.call()

	dialog_box.write(dialog.text)


func _ready() -> void:
	DialogManager.connect_dialog(self)
