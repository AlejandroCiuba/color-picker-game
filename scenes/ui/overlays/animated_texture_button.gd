extends TextureButton
class_name AnimatedTextureButton

var _tween: Tween


func _on_mouse_entered() -> void:

	if _tween != null:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.1)
	_tween.set_trans(Tween.TRANS_SINE)


func _on_mouse_exited() -> void:

	if _tween != null:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector2(1.00, 1.00), 0.1)
	_tween.set_trans(Tween.TRANS_SINE)


func _on_pressed() -> void:

	if _tween != null:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector2(1.00, 1.00), 0.1)
	_tween.set_trans(Tween.TRANS_SINE)


func _ready() -> void:

	pivot_offset_ratio = Vector2(0.5, 0.5)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)
