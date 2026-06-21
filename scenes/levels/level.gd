extends Node2D

var color_saved: bool = false

@onready var hex_code_container: PanelContainer = %HexCodeContainer
@onready var hex_tweens: TweenLibrary = %HexTweenLibrary
@onready var hex_code: RichTextLabel = %HexCode

@onready var casper: Character = %Casper
@onready var casper_tweens: TweenLibrary = %CasperTweenLibrary

@onready var dialog: DialogDisplay = %CasperDialog
@onready var dialog_tweens: TweenLibrary = %DialogTweenLibrary

@onready var color_picker: ColorOverlay = %ColorOverlay
@onready var color_tweens: TweenLibrary = %ColorTweenLibrary


func tween_hex_code_appear() -> void:
	await hex_tweens.appear()
	dialog.dialog_server.next_line()


func tween_color_picker_appear() -> void:
	await color_tweens.appear()
	dialog.dialog_server.next_line()


func tween_dialog_game_position() -> void:
	await dialog_tweens.move(dialog.position, Vector2(246.0, 227.0))
	dialog.dialog_server.next_line()


func tween_dialog_appear() -> void:
	await dialog_tweens.appear()
	dialog.dialog_server.next_line()


func tween_dialog_disappear() -> void:
	await dialog_tweens.move(dialog.position, Vector2(1000.0, 1000.0))


func tween_casper_appear() -> void:
	await casper_tweens.appear()
	casper._tween_animation()
	dialog.dialog_server.next_line()


func tween_casper_disappear() -> void:
	await casper_tweens.disappear()
	casper._tween_animation()
	dialog.dialog_server.next_line()


func tween_casper_game_position() -> void:
	await casper_tweens.move(casper.position, Vector2(147.0, 588.0))
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
	casper.change_color(Color.WHITE)
