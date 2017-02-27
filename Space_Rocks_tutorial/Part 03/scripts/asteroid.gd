extends KinematicBody2D

export var bounce = 1.1

var vel = Vector2()
var rot_speed
var screen_size
var extents

onready var puff = get_node("puff")

func _ready():
	randomize()
	set_fixed_process(true)
	vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2*PI))
	rot_speed = rand_range(-1.5, 1.5)
	screen_size = get_viewport_rect().size
	extents = get_node("sprite").get_texture().get_size() / 2

func _fixed_process(delta):
	set_rot(get_rot() + rot_speed * delta)
	move(vel * delta)
	if is_colliding():
		vel += get_collision_normal() * (get_collider().vel.length() * bounce)
		puff.set_global_pos(get_collision_pos())
		puff.set_emitting(true)
	# wrap around screen edges
	var pos = get_pos()
	if pos.x > screen_size.width + extents.width:
		pos.x = -extents.width
	if pos.x < -extents.width:
		pos.x = screen_size.width + extents.width
	if pos.y > screen_size.height + extents.height:
		pos.y = -extents.height
	if pos.y < -extents.height:
		pos.y = screen_size.height + extents.height
	set_pos(pos)