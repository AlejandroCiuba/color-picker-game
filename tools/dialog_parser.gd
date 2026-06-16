@tool
extends EditorScript

var name_regex: RegEx = RegEx.create_from_string(r"^(?<dialog_id>\w+)")
var callback_regex: RegEx = RegEx.create_from_string(r"\[(?<callbacks>.+)\]")
var text_regex: RegEx = RegEx.create_from_string(r":\s(?<text>.+)$")

var filename: String = "test"
var format: Dictionary = {
	"dialog_id": "",
	"callbacks": [],
}


func _parse_callbacks(text: String) -> PackedStringArray:
	return text.strip_edges().replace(" ", "").split(",")


func _parse_line(line: String) -> Dictionary:

	if line.is_empty():
		return {}

	#print_debug(name_regex.search(line).get_string("dialog_id"))
	#print_debug(callback_regex.search(line).get_string("callbacks"))
	#print_debug(text_regex.search(line).get_string("text"))

	var json: Dictionary = {}
	json[name_regex.search(line).get_string("dialog_id")] = text_regex.search(line).get_string("text")
	json["callbacks"] = _parse_callbacks(callback_regex.search(line).get_string("callbacks"))

	return json

func _run() -> void:

	var file: FileAccess = FileAccess.open("res://assets/text/%s.txt" % filename, FileAccess.READ)

	var lines: PackedStringArray = file.get_as_text().split("\n", false)
	print_debug(lines)

	var savefile: FileAccess = FileAccess.open("res://assets/json/%s.json" % filename, FileAccess.WRITE)
	if FileAccess.get_open_error() != OK:
		push_error("Error opening %s, %d" % [savefile, FileAccess.get_open_error()])

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
