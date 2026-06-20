extends Node2D

var color_saved: bool = false

@onready var hex_code_container: PanelContainer = %HexCodeContainer
@onready var hex_code: RichTextLabel = %HexCode
@onready var casper: Character = %Casper
@onready var dialog: DialogDisplay = %CasperDialog
@onready var color_picker: ColorOverlay = %ColorOverlay


func tween_hex_code_appear() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(hex_code_container, "offset_transform_position", Vector2(0.0, 0.0), 0.75).from_current()
	dialog.dialog_server.next_line()



func tween_color_picker_appear() -> void:
	await color_picker.tween_color_picker_appear()
	dialog.dialog_server.next_line()


func tween_dialog_game_position() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(dialog, "position", Vector2(246.0, 227.0), 0.75).from_current()
	dialog.dialog_server.next_line()


func tween_dialog_appear() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(dialog, "position", Vector2(574.0, 31.0), 0.75).from_current()
	await tween.finished
	dialog.dialog_server.next_line()


func tween_dialog_disappear() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(dialog, "position", Vector2(1000.0, 1000.0), 0.75).from_current()
	await tween.finished


func tween_casper_appear() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(casper, "position", Vector2(344.0, 282.0), 0.75).from_current()
	await tween.finished
	casper._tween_animation()
	dialog.dialog_server.next_line()


func tween_casper_disappear() -> void:

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(casper, "position", Vector2(1000.0, 1000.0), 0.75).from_current()
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


func _on_color_overlay_color_selected(color: Color) -> void:
	if not color_saved:
		hex_code.text = "#%s" % color.to_html()
		color_saved = true
	dialog.dialog_server.next_line()


func _on_color_overlay_color_changed(color: Color) -> void:
	casper.change_color(color)


func _on_game_started() -> void:
	_settings()
	story()


func _settings() -> void:
	dialog.on_early_button_press = Settings.on_next_press
	dialog.word_time = Settings.text_speed
	dialog.autoplay_dialog = Settings.autoplay_dialog


func _ready() -> void:
	hex_code_container.offset_transform_enabled = true
	hex_code_container.offset_transform_position.y = 1000.0
	casper.change_color(Color.WHITE)
