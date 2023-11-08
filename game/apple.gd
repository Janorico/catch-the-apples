extends Sprite


signal failed(apple)
var y_velocity: float = 0.0
var gravity: float = ProjectSettings.get("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	y_velocity += gravity * delta
	position.y += y_velocity * delta
	if position.y >= get_viewport_rect().size.y:
		emit_signal("failed", self)
		queue_free()
