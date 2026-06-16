extends Node

## Notes:
# 1. Dialog starts with a script which is triggered by an event
# 2. Actors in that script receive and request dialog
# 3. Callbacks can be called on the actors to perform certain actions
signal script_started(script: String)
signal dialog_triggered(dialog: Dialog)

const _JSON_FOLDER: StringName = "res://assets/json"

var _current_scene: Node = null
var _current_script: String = ""
var _current_dialog_json: Array = []
var _actors: Dictionary[String, Variant]
var _dialogs: Dictionary[String, DialogDisplay]


func reset_dialogs() -> void:
	_dialogs.clear()


func reset_scene() -> void:
	_actors.clear()


func start_script_in_scene(script: String, scene: Node, begin: bool = false) -> void:

	connect_scene(scene)
	start_script(script)

	if begin:
		line(0)


## Dialog displays connect via this function on their own
func connect_dialog(dialog_display: DialogDisplay) -> void:
	_dialogs[dialog_display.dialog_id] = dialog_display
	dialog_triggered.connect(dialog_display._on_dialog_triggered)


## The main scene connects actors required by the dialog displays
func connect_scene(scene: Node) -> void:
	_current_scene = scene
	#for actor in _current_scene._get_property_list():
		#_actors[actor["name"]] = scene.get(actor["name"])


## The dialog will use its given actors and dialog to start a script
func start_script(script: String) -> Error:

	var file: FileAccess = FileAccess.open("%s/%s.json" % [_JSON_FOLDER, script], FileAccess.READ)
	var json: Dictionary = {}
	if FileAccess.get_open_error() == OK:
		json = JSON.parse_string(file.get_as_text())
		_current_script = json["script"]
		_current_dialog_json = json["dialog"]
		script_started.emit(_current_script)
	return FileAccess.get_open_error()


## Dialog Displays call this when the next line of dialog is required
## {"dialog_id": "text", "callbacks": [{"actor.method", ...]}
func line(ln: int) -> void:

	if _current_script == "":
		push_error("No script assigned in DialogManager, cannot get next line")
		return

	if ln >= _current_dialog_json.size():
		push_error("Line number %d is greater than the number of lines in the script, %d" % [ln, _current_dialog_json.size()])
		return

	dialog_triggered.emit(_create_dialog(_current_dialog_json[ln]))


func _create_dialog(json: Dictionary) -> Dialog:

	var callbacks: Array[Callable] = []
	for callback in json["callbacks"]:

		var comps: PackedStringArray = callback["callback"].split(".")
		if _current_scene.get(comps[0]) == null:
			push_error("Current scene %s does not have property %s" % [_current_scene.name, comps[0]])

		elif _current_scene.get(comps[0]) is not Node:
			push_error("Property %s is not a Node type" % [comps[0]])

		if not _current_scene.get(comps[0]).has_method(comps[1]):
			push_error("Actor %s does not have method %s" % [comps[0], comps[1]])
			return

		var custom: Callable = func(): _current_scene.get(comps[0]).callv(comps[1], callback["args"])
		callbacks.append(custom)

	var with_callbacks: Dictionary = json.duplicate()
	with_callbacks["callbacks"] = callbacks
	return Dialog.from_dictionary(with_callbacks)
