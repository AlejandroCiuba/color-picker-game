class_name Character
extends Node2D

var _shader: ShaderMaterial = preload("res://resources/character/character.tres")
var tween: Tween = null

@export_category("Tween")
@export var _tween_time: float = 0.75
@export var _tween_distance: float = 15.0

@onready var _eyes: Node2D = %Eyes
@onready var _blink: Timer = %Blink
@onready var _animhead: AnimationPlayer = %HeadAnimation
@onready var _animtail: AnimationPlayer = %TailAnimation
@onready var _animarm: AnimationPlayer = %ArmAnimation


func emote(emotion: String = "hru") -> void:

	if emotion == "reset":
		reset()
		return

	if emotion[0] == 'h':
		talk("happy")
	else:
		talk("sad")

	if emotion[1] == 'r':
		arm("raised")
	else:
		arm("lowered")

	if emotion[2] == 'u':
		tail("up")
	else:
		tail("down")


func reset() -> void:
	_animhead.play("animations/RESET")
	_animarm.play("animations/RESET")
	_animtail.play("animations/RESET")


func talk(emotion: String) -> void:
	_animhead.play("animations/talk-%s" % emotion)


func arm(state: String) -> void:
	_animarm.play("animations/%s-hand" % state)


func tail(state: String) -> void:
	_animtail.play("animations/tail-%s" % state)


func change_color(color: Color) -> void:
	_shader.set_shader_parameter("color", color)


func _tween_animation() -> void:

	if tween != null:
		tween.kill()

	tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", -_tween_distance, _tween_time).as_relative()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", _tween_distance, _tween_time).as_relative()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _on_blink_timeout() -> void:
	_eyes.hide()
	await get_tree().create_timer(0.1).timeout
	_eyes.show()
	_blink.start(randf_range(1.0, 5.0))


func _ready() -> void:
	_blink.timeout.connect(_on_blink_timeout)
	_blink.start()
	#_tween_animation()
