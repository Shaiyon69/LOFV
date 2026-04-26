extends CharacterBody2D

@export var speed: float = 75.0
@export var seed_scene: PackedScene = preload("res://scenes/exp_seed.tscn")

var health: int = 30
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		_update_animations()

func _update_animations() -> void:
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				$AnimatedSprite2D.play("right")
			else:
				$AnimatedSprite2D.play("left")
		else:
			if velocity.y > 0:
				$AnimatedSprite2D.play("down")
			else:
				$AnimatedSprite2D.play("up")
	else:
		$AnimatedSprite2D.stop()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		var new_seed = seed_scene.instantiate()
		new_seed.global_position = global_position
		get_parent().call_deferred("add_child", new_seed)
		queue_free()
