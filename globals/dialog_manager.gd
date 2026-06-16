extends Node

## Notes:
# 1. Dialog starts with a script which is triggered by an event
# 2. Actors in that script receive and request dialog
# 3. Callbacks can be called on the actors to perform certain actions
signal script_started(filename: String)
signal dialog_triggered(dialog: Dialog)

var _current_scene: Node = null
var _current_script: FileAccess = null
var _actors: Dictionary[String, Variant]
var _dialogs: Dictionary[String, DialogDisplay]


func reset_dialogs() -> void:
	_dialogs.clear()


func reset_scene() -> void:
	_actors.clear()


## Dialog displays connect via this function on their own
func connect_dialog(dialog_display: DialogDisplay) -> void:
	_dialogs[dialog_display.dialog_id] = dialog_display
	dialog_triggered.connect(dialog_display._on_dialog_triggered)


## The main scene connects actors required by the dialog displays
func connect_scene(scene: Node) -> void:
	_current_scene = scene
	for actor in _current_scene._get_property_list():
		_actors[actor["name"]] = scene.get(actor["name"])


## The dialog will use its given actors and dialog to start a script
func start_script(filename: String) -> Error:
	_current_script = FileAccess.open(filename, FileAccess.READ)
	if FileAccess.get_open_error() == OK:
		script_started.emit(filename)
	return FileAccess.get_open_error()


## Dialog Displays call this when the next line of dialog is required
## {"dialog_id": "text", "callbacks": [{"actor.method", ...]}
func next_line() -> void:

	if _current_script == null:
		push_error("No script assigned in DialogManager, cannot get next line")

	var lines: PackedStringArray = _current_script.get_as_text().split("\n")
	for line in lines:
		var json: Dictionary = JSON.parse_string(line)
		dialog_triggered.emit(_create_dialog(json))


func _create_dialog(json: Dictionary) -> Dialog:

	var callbacks: Array[Callable] = []
	for callback in json["callbacks"]:

		var comps: PackedStringArray = callback.split(".")
		if _current_scene.get(comps[0]) == null:
			push_error("Current scene %s does not have property %s" % [_current_scene.name, comps[0]])

		if _current_scene.get(comps[0]) is not Node:
			push_error("Property %s is not a Node type" % [comps[0]])

		if not _current_scene.get(comps[0]).has_method(comps[1]):
			push_error("Actor %s does not have method %s" % [comps[0], comps[1]])

		var custom: Callable = func(): _current_scene.get(comps[0]).call(comps[1])
		callbacks.append(custom)

	var with_callbacks: Dictionary = json.duplicate()
	with_callbacks["callbacks"] = callbacks
	return Dialog.from_dictionary(with_callbacks)
