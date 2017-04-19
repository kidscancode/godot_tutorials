extends Node


var asteroid = preload("res://scenes/asteroid.tscn")
var explosion = preload("res://scenes/explosion.tscn")
onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var expl_sounds = get_node("expl_sounds")
onready var HUD = get_node("HUD")

func _ready():
	set_process(true)
	get_node("music").play()

func show_hud_shield():
	var shield_level = get_node("player").shield_level
	var color = "green"
	if shield_level < 40:
		color = "red"
	elif shield_level < 70:
		color = "yellow"
	var texture = load("res://art/gui/barHorizontal_%s_mid 200.png" % color)
	HUD.get_node("shield_bar").set_progress_texture(texture)
	HUD.get_node("shield_bar").set_value(shield_level)

func _process(delta):
	show_hud_shield()
	HUD.get_node("score").set_text(str(global.score))
	if asteroid_container.get_child_count() == 0:
		global.level += 1
		for i in range(global.level):
			spawn_asteroid("big", spawns.get_child(i).get_pos(),
					   Vector2(0, 0))

func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = global.break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(25) * offset
			var newvel = (vel + hit_vel.tangent() * offset) * 0.9
			spawn_asteroid(newsize, newpos, newvel)
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.play()
	expl_sounds.play("expl1")