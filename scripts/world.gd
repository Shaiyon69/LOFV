extends Node2D

@export var slime_scene: PackedScene = preload("res://scenes/slime.tscn")

# We need a reference to the player to find the spawn path
@onready var player = $Player 

func _on_spawn_timer_timeout() -> void:
	# 1. Access the PathFollow2D inside the Player scene
	var spawn_path = player.get_node("Path2D/PathFollow2D")
	
	# 2. Pick a random spot on that path
	spawn_path.progress_ratio = randf()
	
	# 3. Create and position the slime
	var new_slime = slime_scene.instantiate()
	new_slime.global_position = spawn_path.global_position
	
	# 4. Add the slime as a child of the World
	add_child(new_slime)
