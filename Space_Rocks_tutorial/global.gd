extends Node

# game settings
var screensize = Vector2()
var game_over = false
var score = 0
var level = 0
var paused = false
var current_scene = null
var new_scene = null

# player settings
var shield_max = 100
var bullet_damage = 10
var cash = 0
var upgrade_level = {'thrust': 3,
					 'fire_rate': 3,
					 'rot_speed': 3,
					 'shield_regen': 3,
					 'guns': 3}
					
var thrust_level = {1: 200, 2: 400, 3: 600, 4: 800}
var rot_level = {1: 1.5, 2: 2.5, 3: 3.5, 4: 4.5}
var shield_level = {1: 5, 2: 7.5, 3: 10, 4: 15}
var fire_level = {1: 0.4, 2: 0.3, 3: 0.2, 4: 0.1}

# enemy settings
var enemy_health = 30
var enemy_bullet_damage = 25
var enemy_speed = 175
var enemy_accuracy = 0.1
var enemy_points = 100

# asteroid settings
var break_pattern = {'big': 'med', 'med': 'sm', 'sm': 'tiny', 'tiny': null}
var rock_mass = {'big': 20, 'med': 9, 'sm': 5, 'tiny': 1}
var rock_damage = {'big': 40, 'med': 20, 'sm': 15, 'tiny': 10}
var rock_points = {'big': 10, 'med': 15, 'sm': 20, 'tiny': 40}

func _ready():
	screensize = get_viewport().size
	var root = get_tree().get_root()
	# TODO: change this when adding start screen
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	var s = ResourceLoader.load(path)
	new_scene = s.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	current_scene.queue_free()
	current_scene = new_scene
	
func new_game():
	game_over = false
	score = 0
	level = 0
	goto_scene("res://Main.tscn")
	
	
	