extends Area2D

@export var exp_value: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("gain_experience"):
			body.gain_experience(exp_value)
		queue_free()
