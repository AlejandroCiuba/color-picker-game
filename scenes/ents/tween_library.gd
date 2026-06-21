@tool
class_name TweenLibrary
extends Node

signal tween_finished(node: Node)

@export var _play: bool = false:
	set(value):
		if Engine.is_editor_hint() and value:
			_cycle_tweens()
			_play = false

@export var node: Node = null

@export_category("Tween Settings")
## Use position instead of offset_position for control node
@export var use_position: bool = false
@export var start_position: Vector2 = Vector2.ZERO
@export var end_position: Vector2 = Vector2.ZERO
@export var tween_time: float = 0.75
@export var transition: Tween.TransitionType = Tween.TRANS_BACK
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT


func appear() -> void:
	await move()


func disappear() -> void:
	if node is Control and not use_position:
		await move(node.offset_transform_position, start_position)
	else:
		await move(node.position, start_position)


func move(from: Vector2 = start_position, to: Vector2 = end_position) -> void:
	var tween: Tween = node.create_tween()
	tween.set_trans(transition).set_ease(ease_type)
	if node is Control and not use_position:
		tween.tween_property(node, "offset_transform_position", to, tween_time).from(from)
	else:
		tween.tween_property(node, "position", to, tween_time).from(from)
	await tween.finished
	tween_finished.emit(node)


func _cycle_tweens() -> void:
	if node == null:
		return

	var opos: Vector2 = node.position
	if node is Control and not use_position:
		node.offset_transform_enabled = true
		opos = node.offset_transform_position

	await appear()
	await disappear()

	if node is Control and not use_position:
		node.offset_transform_position = opos
		node.offset_transform_enabled = false
	else:
		node.position = opos


func _ready() -> void:
	if node == null:
		return
	if node is Control and not use_position:
		node.offset_transform_enabled = true
		node.offset_transform_position = start_position
	else:
		use_position = true
		node.position = start_position
