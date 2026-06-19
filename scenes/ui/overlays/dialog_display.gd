class_name DialogDisplay
extends Control

signal write_finished()

var finished_write: bool = true
var dump_text: bool = false

@export var dialog_id: String = ""

@export_category("Dialog Settings")
@export var word_time: float = 0.1
@export_enum("Nothing", "Dump Text", "Skip") var on_early_button_press: String = "Dump Text"
@export var autoplay_dialog: bool = false

@onready var pause_timer: Timer = %PauseTimer
@onready var dialog: RichTextLabel = %RichTextLabel
@onready var dialog_server: DialogServer = %DialogServer


func pause(time: float) -> void:
	for i in range(int(time * 1E2)):
		pause_timer.start(word_time)
		await pause_timer.timeout
		if dump_text or finished_write:
			return

## Writes the series of texts, calling each callable associated with each text section
## Write NULL if a text section has no callable
func write(texts: Array, calls: Array) -> void:

	if not finished_write:
		return

	finished_write = false
	dump_text = false

	dialog.text = "".join(texts)
	dialog.visible_characters = 0

	for i in range(texts.size()):
		await _process_callback(calls[i]["callback"], calls[i]["args"])
		await _tween_text(texts[i])

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
		if finished_write:
			return
		if dump_text:
			dialog.visible_characters = -1
			return
		dialog.visible_characters += 1
		await get_tree().create_timer(word_time, false).timeout


func _on_dialog_server_text_fetched(text: Array) -> void:

	var texts: Array = text.map(func(t): return t["text"])
	var calls: Array = text.map(func(t): return t["callback"])
	write(texts, calls)


func _on_button_pressed() -> void:

	if not finished_write and on_early_button_press == "Dump Text":
		dump_text = true
		return
	elif not finished_write and on_early_button_press == "Nothing":
		return
	elif not finished_write and on_early_button_press == "Skip":
		finished_write = true

	dialog.text = ""
	dialog_server.next_line()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and finished_write:
		write(["Hello, how are you?"], [])


func _ready() -> void:
	dialog.text = ""
	dialog_server.dialog_id = dialog_id
