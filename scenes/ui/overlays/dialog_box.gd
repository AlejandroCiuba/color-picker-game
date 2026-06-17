class_name DialogBox
extends Control

signal write_finished()

var finished_write: bool = true

@export var dialog_id: String = ""
@export var _word_time: float = 0.1

@onready var dialog: RichTextLabel = %RichTextLabel
@onready var dialog_display: DialogDisplay = %DialogDisplay


func pause(time: float) -> void:
	await get_tree().create_timer(time, false).timeout


## Writes the series of texts, calling each callable associated with each text section
## Write NULL if a text section has no callable
func write(texts: Array, calls: Array) -> void:

	if not finished_write:
		return

	finished_write = false
	dialog.text = "".join(texts)
	dialog.visible_characters = 0
	for i in range(texts.size()):
		await _process_callback(calls[i]["callback"], calls[i]["args"])
		_tween_text(texts[i])
	finished_write = true
	write_finished.emit()


func _process_callback(f: String, args: Array) -> void:
	if f != "NULL":
		if not has_method(f):
			push_error("Dialog Box has no method %s" % f)
			return
		await callv(f, args.map(func(a): return str_to_var(a)))


func _tween_text(text: String) -> void:
	for i in text.length():
		dialog.visible_characters += 1
		await get_tree().create_timer(_word_time, false).timeout


func _on_dialog_display_text_fetched(texts: Array, calls: Array) -> void:
	write(texts, calls)


func _on_button_pressed() -> void:
	finished_write = true
	write_finished.emit()
	dialog.text = ""
	dialog_display.next_line()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and finished_write:
		write(["Hello, how are you?"], [])


func _ready() -> void:
	dialog.text = ""
	dialog_display.dialog_id = dialog_id
