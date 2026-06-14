extends Node2D
class_name Character

var _shader: ShaderMaterial = preload("res://resources/character.tres")

@export_category("Tween")
@export var _tween_time: float = 0.75
@export var _tween_distance: float = 15.0

@onready var _eyes: Node2D = %Eyes
@onready var _blink: Timer = %Blink
@onready var _anim: AnimationPlayer = %AnimationPlayer


func change_color(color: Color) -> void:
	_shader.set_shader_parameter("color", color)


func _tween_animation() -> void:

	var tween: Tween = create_tween()
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


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("ui_left"):
		_anim.play("talk-happy")
	elif Input.is_action_just_pressed("ui_right"):
		_anim.play("talk-sad")
	elif Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		_anim.play("RESET")


func _ready() -> void:
	_blink.timeout.connect(_on_blink_timeout)
	_blink.start()
	_tween_animation()
