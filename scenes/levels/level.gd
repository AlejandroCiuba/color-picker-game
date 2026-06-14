extends Node2D

@onready var character: Character = %Casper
@onready var dialog_canvas: Control = %DialogBox


func _on_color_picker_color_changed(color: Color) -> void:
	character.change_color(color)


func _ready() -> void:
	character.change_color(Color.WHITE)
