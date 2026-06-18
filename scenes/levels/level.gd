extends Node2D

@onready var casper: Character = %Casper
@onready var dialog: DialogDisplay = %CasperDialog
@onready var color_control: Control = %ColorControl


func tween_color_picker_appear() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(color_control, "position:x", 0.0, 0.75).from_current()


func tween_dialog_game_position() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(dialog, "position", Vector2(246.0, 227.0), 0.75).from_current()


func tween_dialog_appear() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(dialog, "position", Vector2(574.0, 31.0), 0.75).from_current()
	await tween.finished
	dialog.dialog_server.next_line()


func tween_casper_appear() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(casper, "position", Vector2(344.0, 282.0), 0.75).from_current()
	await tween.finished
	casper._tween_animation()
	dialog.dialog_server.next_line()


func tween_casper_game_position() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(casper, "position", Vector2(147.0, 588.0), 0.75).from_current()
	await tween.finished
	casper._tween_animation()


func story() -> void:
	casper.show()
	dialog.show()
	DialogManager.start_script_in_scene("game-dialog", self, true, true)


func _on_color_picker_color_changed(color: Color) -> void:
	casper.change_color(color)


func _on_start_menu_game_started() -> void:
	story()


func _ready() -> void:
	color_control.position.x = 1000.0
	casper.change_color(Color.WHITE)
