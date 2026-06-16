class_name Dialog
extends Resource

var dialog_id: String = ""
var text: String = ""
var callbacks: Array[Callable] = []


static func from_dictionary(dict: Dictionary) -> Dialog:
	return Dialog.new(dict["dialog_id"], dict["text"], dict["callbacks"])


func _init(id: String, t: String, c: Array[Callable]) -> void:
	dialog_id = id
	text = t
	callbacks = c
