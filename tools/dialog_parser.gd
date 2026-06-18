@tool
extends EditorScript

var name_regex: RegEx = RegEx.create_from_string(r"^(?<dialog_id>\w+)")
var callback_regex: RegEx = RegEx.create_from_string(r"\[(?<callbacks>.+)\](?::|$)")
var methods_regex: RegEx = RegEx.create_from_string(r"(?<method>[a-zA-Z][\w_]+\.[a-zA-Z][\w_]+(?:\([^\(\)]*\))?)")
var args_regex: RegEx = RegEx.create_from_string(r"\((?<args>.+)\)")
var text_regex: RegEx = RegEx.create_from_string(r":\s(?<text>.+)$")
var intext_calls: RegEx = RegEx.create_from_string(r"(?<method><[a-zA-Z][\w_]+(?:\([^\(\)]*\))?>)")

var filename: String = "game-dialog"
var format: Dictionary = {
	"dialog_id": "",
	"text": [],
	"callbacks": [],
}

var callback_format: Dictionary = {
	"callback": "",
	"args": [],
}

var text_format: Dictionary = {
	"text": "",
	"callback": callback_format,
}


func _parse_callbacks(text: String) -> Array:

	var clean: String = text.strip_edges().replace(" ", "")
	var methods: Array[RegExMatch] = methods_regex.search_all(clean)

	var callbacks: Array = []
	for method in methods:
		var m: String = method.get_string("method")
		print_debug(m)
		var callback: Dictionary = {}
		var args: RegExMatch = args_regex.search(m)
		print_debug(args)
		if args != null:
			callback["args"] = args.get_string("args").split(",")
		else:
			callback["args"] = []
		callback["callback"] = m.split("(", false)[0]
		callbacks.append(callback)

	return callbacks


## Handle in-text callbacks to the dialog box
func _parse_dialog_text(text: String) -> Array[Dictionary]:

	var calls: Array[RegExMatch] = intext_calls.search_all(text)
	if calls.is_empty():
		return [
			{
				"text": text,
				"callback": {
					"callback": "NULL",
					"args": [],
				},
			},
		]

	else:

		var marker_text: String = text
		if calls[0].get_start("method") != 0:
			marker_text = "<NULL>" + marker_text
			calls = intext_calls.search_all(marker_text)

		var texts: Array[Dictionary] = []
		for i in range(calls.size()):

			var t_dict: Dictionary = text_format.duplicate(true)
			var cb_dict: Dictionary = callback_format.duplicate(true)

			var phrase_start: int = calls[i].get_end("method")
			var phrase_end: int = calls[i + 1].get_start("method") if i < calls.size() - 1 else marker_text.length()

			var t: String = marker_text.substr(phrase_start, phrase_end - phrase_start)
			var c: String = calls[i].get_string("method")

			cb_dict["callback"] = c.remove_chars("<>").split("(")[0]

			if args_regex.search(c) == null:
				cb_dict["args"] = []
			else:
				cb_dict["args"] = args_regex.search(c).get_string("args").split(",")

			t_dict["text"] = t
			t_dict["callback"] = cb_dict

			texts.append(t_dict)

		return texts


func _parse_line(line: String) -> Dictionary:

	if line.is_empty():
		return {}

	var json: Dictionary = {}
	if name_regex.search(line):
		print_debug(name_regex.search(line).get_string("dialog_id"))
		json["dialog_id"] = name_regex.search(line).get_string("dialog_id")
	if text_regex.search(line):
		print_debug(text_regex.search(line).get_string("text"))
		json["text"] = _parse_dialog_text(text_regex.search(line).get_string("text"))
	if callback_regex.search(line):
		print_debug(callback_regex.search(line).get_string("callbacks"))
		json["callbacks"] = _parse_callbacks(callback_regex.search(line).get_string("callbacks"))

	return json

func _run() -> void:

	var file: FileAccess = FileAccess.open("res://assets/text/%s.txt" % filename, FileAccess.READ)

	var lines: PackedStringArray = file.get_as_text().split("\n", false)
	print_debug(lines)

	var savefile: FileAccess = FileAccess.open("res://assets/json/%s.json" % filename, FileAccess.WRITE)
	if FileAccess.get_open_error() != OK:
		push_error("Error opening %s, %d" % [savefile, FileAccess.get_open_error()])
		return

	var json: Dictionary = {}
	json["script"] = filename
	json["dialog"] = []
	for line in lines:
		var json_line: Dictionary = _parse_line(line)
		json["dialog"].append(json_line)

	var json_str: String = JSON.stringify(json, "\t")
	print_debug(json_str)
	savefile.store_line(json_str)

	savefile.close()
