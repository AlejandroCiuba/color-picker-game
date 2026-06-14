extends Control



@export var _word_time: float = 0.1




@onready var dialog: RichTextLabel = %RichTextLabel


func write(text: String) -> void:
	_tween_text(text)


func _tween_text(text: String) -> void:
	var words: PackedStringArray = text.split(" ")
	for word in words:
		dialog.text += " " + text
		await get_tree().create_timer(_word_time, false).timeout


func _ready() -> void:
	dialog.text = ""
