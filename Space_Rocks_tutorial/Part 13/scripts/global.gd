extends Node

# game settings
var game_over = false
var score = 0
var level = 0
var paused = false
var current_scene = null
var new_scene = null

# player settings
var shield_max = 100
var shield_regen = 10
var bullet_damage = 10
var cash = 0
var upgrade_level = {'thrust': 1,
                     'fire_rate': 1,
                     'rot': 1,
                     'shield_regen': 1,
                     'guns': 1}
var thrust_level = {1: 200, 2: 400, 3: 600, 4: 800}
var rot_level = {1: 1.5, 2: 2.5, 3: 3.5, 4: 4.5}
var shield_level = {1: 5, 2: 7.5, 3: 10, 4: 15}
var fire_level = {1: 0.4, 2: 0.3, 3: 0.2, 4: 0.1}

# enemy settings
var enemy_bullet_damage = 25
var enemy_health = 30
var enemy_points = 100

# asteroid settings
var break_pattern = {'big': 'med',
					 'med': 'sm',
					 'sm': 'tiny',
					 'tiny': null}

var ast_damage = {'big': 40,
			  	  'med': 20,
		      	  'sm': 15,
			  	  'tiny': 10}

var ast_points = {'big': 10,
			  	  'med': 15,
		      	  'sm': 20,
			  	  'tiny': 40}

func _ready():
	var root = get_tree().get_root()
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
	goto_scene("res://scenes/main.tscn")