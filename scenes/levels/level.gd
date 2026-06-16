extends Node2D

@onready var casper: Character = %Casper
@onready var dialog: DialogBox = %DialogBox


func tween_casper_appear() -> void:

	dialog.hide()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(casper, "position", Vector2(147.0, 588.0), 0.75).from_current()
	await tween.finished
	dialog.show()
	casper._tween_animation()
	dialog.dialog_display.next_line()


func _story() -> void:
	DialogManager.start_script_in_scene("test", self, true, true)


func _on_color_picker_color_changed(color: Color) -> void:
	casper.change_color(color)


func _ready() -> void:
	casper.change_color(Color.WHITE)
	_story()
