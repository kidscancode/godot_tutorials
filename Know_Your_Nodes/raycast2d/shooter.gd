extends Node

var explosion = preload("res://explosion.tscn")
var trail = preload("res://trail.tscn")

onready var player = get_node("player")

func _ready():
	player.connect("hit", self, "show_hit")

func show_hit(gun_location, hit_location):
	# puff of smoke
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(hit_location)
	expl.set_emitting(true)
	# bullet trail
	var t = trail.instance()
	add_child(t)
	t.set_pos(gun_location)
	var d = hit_location - gun_location
	t.set_region_rect(Rect2(0, 0, d.length(), 2))
	t.set_rot(-d.angle_to(Vector2(1, 0)))