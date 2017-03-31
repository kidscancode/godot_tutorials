extends Node

var break_pattern = {'big': 'med',
					 'med': 'sm',
					 'sm': 'tiny',
					 'tiny': null}

var asteroid = preload("res://scenes/asteroid.tscn")
onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")

func _ready():
	set_process(true)
	for i in range(1):
		spawn_asteroid("big", spawns.get_child(i).get_pos(),
					   Vector2(0, 0))

func _process(delta):
	if asteroid_container.get_child_count() == 0:
		for i in range(2):
			spawn_asteroid("big", spawns.get_child(i).get_pos(),
					   Vector2(0, 0))

func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(25) * offset
			var newvel = (vel + hit_vel.tangent() * offset) * 0.9
			spawn_asteroid(newsize, newpos, newvel)