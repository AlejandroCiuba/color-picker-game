class_name DialogBox
extends Control

signal write_finished()

var finished_write: bool = true

@export var dialog_id: String = ""
@export var _word_time: float = 0.1

@onready var dialog: RichTextLabel = %RichTextLabel
@onready var dialog_display: DialogDisplay = %DialogDisplay


func write(text: String) -> void:
	_tween_text(text)


func _tween_text(text: String) -> void:

	if not finished_write:
		return

	finished_write = false
	dialog.visible_characters = 0
	dialog.text = text
	for i in text.length():
		dialog.visible_characters += 1
		await get_tree().create_timer(_word_time, false).timeout
	finished_write = true
	write_finished.emit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and finished_write:
		write("Hello, how are you?")


func _on_button_pressed() -> void:
	dialog.text = ""


func _ready() -> void:
	dialog.text = ""
