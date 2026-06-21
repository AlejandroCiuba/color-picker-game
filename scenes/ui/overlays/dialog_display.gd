class_name DialogDisplay
extends Control

signal write_finished()

var finished_write: bool = true
var dump_text: bool = false
var force_next_line: bool = false

@export var dialog_id: String = ""
@export var dialog: RichTextLabel = null
@export var next_button: BaseButton = null

@export_category("Dialog Settings")
@export var word_time: float = 0.1
@export_enum("Nothing", "Dump Text", "Skip") var on_early_button_press: String = "Dump Text"
@export var autoplay_dialog: bool = false

@onready var pause_timer: Timer = %PauseTimer
@onready var dialog_server: DialogServer = %DialogServer


func show_next_button() -> void:
	next_button.disabled = false
	next_button.show()


func hide_next_button() -> void:
	next_button.disabled = true
	next_button.hide()


func clear_dialog() -> void:
	dialog.text = ""


func next_line(time) -> void:

	var from_actor: bool = false  ## Forces next line if called from brackets
	if time is String:
		from_actor = true
		time = float(time)

	for i in range(int(time * 1E2)):
		pause_timer.start(word_time)
		await pause_timer.timeout
		if (dump_text or finished_write) and not from_actor:
			force_next_line = true
			return

	if not from_actor:
		force_next_line = true
		return

	dialog_server.next_line()


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

	if autoplay_dialog or force_next_line:
		force_next_line = false
		dialog_server.next_line()


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
		if i % 2 == 0:
			$%AudioStreamPlayer.play()
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


func _ready() -> void:
	if next_button != null:
		next_button.pressed.connect(_on_button_pressed)
	dialog.text = ""
	dialog_server.dialog_id = dialog_id
