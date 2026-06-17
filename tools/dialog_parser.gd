@tool
extends EditorScript

var name_regex: RegEx = RegEx.create_from_string(r"^(?<dialog_id>\w+)")
var callback_regex: RegEx = RegEx.create_from_string(r"\[(?<callbacks>.+)\](?::|$)")
var methods_regex: RegEx = RegEx.create_from_string(r"(?<method>[a-zA-Z][\w_]+\.[a-zA-Z][\w_]+(?:\([^\(\)]*\))?)")
var args_regex: RegEx = RegEx.create_from_string(r"\((?<args>.+)\)")
var text_regex: RegEx = RegEx.create_from_string(r":\s(?<text>.+)$")

var filename: String = "game-dialog"
var format: Dictionary = {
	"dialog_id": "",
	"text": "",
	"callbacks": [],
}

var callback_format: Dictionary = {
	"callback": "",
	"args": [],
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


func _parse_line(line: String) -> Dictionary:

	if line.is_empty():
		return {}

	var json: Dictionary = {}
	if name_regex.search(line):
		print_debug(name_regex.search(line).get_string("dialog_id"))
		json["dialog_id"] = name_regex.search(line).get_string("dialog_id")
	if text_regex.search(line):
		print_debug(text_regex.search(line).get_string("text"))
		json["text"] = text_regex.search(line).get_string("text")
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
