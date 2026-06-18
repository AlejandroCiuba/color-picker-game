class_name Dialog
extends Resource

var dialog_id: String = ""
var text: Array = []
var callbacks: Array = []

var callback_format: Dictionary = {
	"callback": "",
	"args": [],
}

var text_format: Dictionary = {
	"text": "",
	"callback": callback_format,
}


static func from_dictionary(dict: Dictionary) -> Dialog:
	return Dialog.new(dict["dialog_id"], dict["text"], dict["callbacks"])


func _init(id: String, t: Array, c: Array[Callable]) -> void:
	dialog_id = id
	text = t
	callbacks = c
