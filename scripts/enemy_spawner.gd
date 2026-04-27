extends Node2D

@export var slime_scene: PackedScene = preload("res://scenes/slime.tscn")
@export var spawn_radius: float = 800.0

var player: Node2D
var min_wait_time: float = 0.5
var spawn_count: int = 1
var boss_spawned: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_spawn_timer_timeout() -> void:
	if not player:
		return
		
	for i in range(spawn_count):
		var angle = randf_range(0.0, TAU)
		var spawn_offset = Vector2.RIGHT.rotated(angle) * spawn_radius
		
		var new_slime = slime_scene.instantiate()
		new_slime.global_position = player.global_position + spawn_offset
		
		var enemy_types = ["basic", "brute", "runner"]
		var random_type = enemy_types[randi() % enemy_types.size()]
		
		get_parent().add_child(new_slime)
		new_slime.apply_stats(Data.ENEMIES[random_type])

func _on_difficulty_timer_timeout() -> void:
	if not player:
		return

	if player.time_survived >= 300.0 and not boss_spawned:
		_spawn_boss()
		return

	if $SpawnTimer.wait_time > min_wait_time:
		$SpawnTimer.wait_time -= 0.05
	else:
		spawn_count += 1

func _spawn_boss() -> void:
	boss_spawned = true
	
	var angle = randf_range(0.0, TAU)
	var spawn_offset = Vector2.RIGHT.rotated(angle) * spawn_radius
	
	var boss_slime = slime_scene.instantiate()
	boss_slime.global_position = player.global_position + spawn_offset
	
	get_parent().add_child(boss_slime)
	boss_slime.apply_stats(Data.ENEMIES["boss"])
