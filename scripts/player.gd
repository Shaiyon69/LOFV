extends CharacterBody2D

@export var speed: float = 150.0
@export var max_health: float = 100.0

var current_health: float

func _ready() -> void:
	current_health = max_health
	%HealthBar.max_value = max_health
	%HealthBar.value = current_health

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	_update_animations(direction)
	_handle_damage(delta)

func _update_animations(dir: Vector2) -> void:
	if dir.length() > 0:
		if abs(dir.x) > abs(dir.y):
			%AnimatedSprite2D.play("right" if dir.x > 0 else "left")
		else:
			%AnimatedSprite2D.play("down" if dir.y > 0 else "up")
	else:
		%AnimatedSprite2D.stop()

func _handle_damage(delta: float) -> void:
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	
	if overlapping_mobs.size() > 0:
		var damage_rate = 10.0
		current_health -= damage_rate * overlapping_mobs.size() * delta
		
		%HealthBar.value = current_health
		
		if current_health <= 0.0:
			print("Player Died!")
