class_name Dialog
extends Control

@export var _word_time: float = 0.1

@export_category("Tween")
@export var _tween_time: float = 0.75
@export var _tween_distance: float = 15.0

@onready var dialog: RichTextLabel = %RichTextLabel


func write(text: String) -> void:
	_tween_text(text)


func _tween_text(text: String) -> void:
	var words: PackedStringArray = text.split(" ")
	for word in words:
		dialog.text += " " + text
		await get_tree().create_timer(_word_time, false).timeout


func _tween_animation() -> void:

	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", -_tween_distance, _tween_time).as_relative()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", _tween_distance, _tween_time).as_relative()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		write("Hello, how are you?")


func _ready() -> void:
	dialog.text = ""
	#_tween_animation()
