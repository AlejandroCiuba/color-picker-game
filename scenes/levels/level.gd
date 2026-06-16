extends Node2D

@onready var casper: Character = %Casper
@onready var dialog: DialogBox = %DialogBox


func _story() -> void:
	DialogManager.start_script_in_scene("test", self, true)


func _on_color_picker_color_changed(color: Color) -> void:
	casper.change_color(color)


func _ready() -> void:
	casper.change_color(Color.WHITE)
	_story()
