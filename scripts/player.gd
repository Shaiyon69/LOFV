extends CharacterBody2D

@export var speed: float = 150.0
@export var max_health: float = 100.0

var level: int = 1
var current_exp: int = 0
var exp_to_next_level: int = 5
var current_health: float
var bonus_damage: int = 0
var time_survived: float = 0.0
var kill_count: int = 0
var fire_rate_multiplier: float = 1.0

@onready var hud = $HUD

func _ready() -> void:
	current_health = max_health
	hud.update_health(current_health, max_health)
	hud.update_exp(current_exp, exp_to_next_level)
	hud.update_level(level)
	
	hud.upgrade_selected.connect(_apply_upgrade)
	%MagnetZone.area_entered.connect(_on_magnet_zone_area_entered)

func _on_magnet_zone_area_entered(area: Area2D) -> void:
	if area.has_method("pull_to_player"):
		area.pull_to_player(self)

func _physics_process(delta: float) -> void:
	# Timer calculation
	time_survived += delta
	var minutes = int(time_survived) / 60
	var seconds = int(time_survived) % 60
	hud.update_time(minutes, seconds)

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	_update_animations(direction)
	_handle_damage(delta)

func add_kill() -> void:
	kill_count += 1
	hud.update_kills(kill_count)

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
		
		hud.update_health(current_health, max_health)
		
		if current_health <= 0.0:
			get_tree().paused = true
			hud.show_game_over()

func gain_experience(amount: int) -> void:
	current_exp += amount
	if current_exp >= exp_to_next_level:
		level_up()
	hud.update_exp(current_exp, exp_to_next_level)

func level_up() -> void:
	current_exp -= exp_to_next_level
	level += 1
	exp_to_next_level = int(exp_to_next_level * 1.5)
	
	current_health = max_health
	
	hud.update_health(current_health, max_health)
	hud.update_exp(current_exp, exp_to_next_level)
	hud.update_level(level)
	
	get_tree().paused = true
	hud.show_level_up()

func _apply_upgrade(upgrade_name: String) -> void:
	if upgrade_name == "max_hp":
		max_health += 50.0
		current_health += 50.0
	elif upgrade_name == "speed":
		speed += 25.0
	elif upgrade_name == "damage":
		bonus_damage += 15
	elif upgrade_name == "pickup_range":
		var shape = %MagnetZone.get_node("CollisionShape2D").shape as CircleShape2D
		shape.radius += 25.0
	elif upgrade_name == "fire_rate":
		fire_rate_multiplier += 0.1
	else:
		_acquire_weapon(upgrade_name)
		
	hud.update_health(current_health, max_health)

func _acquire_weapon(weapon_id: String) -> void:
	if Data.WEAPONS.has(weapon_id):
		var weapon_data = Data.WEAPONS[weapon_id]
		var weapon_scene = load(weapon_data["scene_path"])
		var new_weapon = weapon_scene.instantiate()
		
		add_child(new_weapon)
