extends Node

const WEAPONS = {
	"poison_aura": {
		"display_name": "Poison Aura",
		"base_damage": 15,
		"scene_path": "res://scenes/poison.tscn"
	},
	"vine_whip": {
		"display_name": "Vine Whip",
		"base_damage": 20,
		"scene_path": "res://scenes/vine_whip.tscn"
	}
}

const ENEMIES = {
	"basic": {"health": 30, "speed": 75.0, "scale": 1.0, "color": Color(1.0, 1.0, 1.0)},
	"brute": {"health": 90, "speed": 40.0, "scale": 1.5, "color": Color(1.0, 0.4, 0.4)},
	"runner": {"health": 15, "speed": 130.0, "scale": 0.8, "color": Color(0.4, 0.4, 1.0)},
	"boss": {"health": 5000, "speed": 60.0, "scale": 4.0, "color": Color(0.8, 0.1, 0.8)}
}
