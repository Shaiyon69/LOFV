extends CharacterBody2D

@export var seed_scene: PackedScene = preload("res://scenes/exp_seed.tscn")

var speed: float
var health: int
var player: Node2D
var despawn_distance: float = 1500.0

@onready var soft_collision = $SoftCollision

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func apply_stats(stats: Dictionary) -> void:
	health = stats["health"]
	speed = stats["speed"]
	scale = Vector2(stats["scale"], stats["scale"])
	$AnimatedSprite2D.modulate = stats["color"]

func _physics_process(_delta: float) -> void:
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance > despawn_distance:
			queue_free()
			return
			
		var push_vector = Vector2.ZERO
		if soft_collision.has_overlapping_areas():
			var areas = soft_collision.get_overlapping_areas()
			for area in areas:
				push_vector += area.global_position.direction_to(global_position)
				
		var direction = global_position.direction_to(player.global_position)
		velocity = (direction * speed) + (push_vector * 20.0)
		
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
		if player and player.has_method("add_kill"):
			player.add_kill()
			
		var new_seed = seed_scene.instantiate()
		new_seed.global_position = global_position
		get_parent().call_deferred("add_child", new_seed)
		queue_free()
