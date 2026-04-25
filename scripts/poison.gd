extends Area2D

@export var damage: int = 15

func _on_attack_timer_timeout() -> void:
	var enemies = get_overlapping_bodies()
	$AnimatedSprite2D.play("poison")
	
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)
