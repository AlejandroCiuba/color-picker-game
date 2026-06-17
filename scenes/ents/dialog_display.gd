class_name DialogDisplay
extends Node

signal text_fetched(text: Array, calls: Array)

var intext_calls: RegEx = RegEx.create_from_string(r"(?<method><[a-zA-Z][\w_]+(?:\([^\(\)]*\))?>)")
var args_regex: RegEx = RegEx.create_from_string(r"\((?<args>.+)\)")

var callback_format: Dictionary = {
	"callback": "",
	"args": [],
}

var dialog_id: String = ""
var current_line: int = 0


func next_line() -> void:
	DialogManager.line(current_line)


## Handle in-text callbacks to the dialog box
func _process_dialog_text(text: String) -> Array:

	var calls: Array[RegExMatch] = intext_calls.search_all(text)
	if calls.is_empty():
		return [[text], [{"callback": "NULL", "args": []}]]

	else:

		var marker_text: String = text
		if calls[0].get_start("method") != 0:
			marker_text = "<NULL>" + marker_text
			calls = intext_calls.search_all(marker_text)

		var texts: Array[String] = []
		var cs: Array[Dictionary] = []
		for i in range(calls.size()):

			var phrase_start: int = calls[i].get_end("method")
			var phrase_end: int = calls[i + 1].get_start("method") if i < calls.size() - 1 else marker_text.length()

			var t: String = marker_text.substr(phrase_start, phrase_end - phrase_start)
			var c: String = calls[i].get_string("method")

			var cb_dict: Dictionary = callback_format.duplicate(true)
			cb_dict["callback"] = c.remove_chars("<>").split("(")[0]

			if args_regex.search(c) == null:
				cb_dict["args"] = []
			else:
				cb_dict["args"] = args_regex.search(c).get_string("args").split(",")

			texts.append(t)
			cs.append(cb_dict)

		return [texts, cs]

## Perform the callbacks, then display text
func _on_dialog_triggered(dialog: Dialog) -> void:

	current_line += 1
	if dialog.dialog_id != dialog_id:
		return

	for callback in dialog.callbacks:
		callback.call()

	## Handle in-text callbacks
	var data: Array = _process_dialog_text(dialog.text)
	text_fetched.emit(data[0], data[1])


func _ready() -> void:
	DialogManager.connect_dialog(self)
