extends KinematicBody2D

signal hit

const accel = 1200
const friction = -800
const rot_speed = PI  # radians/sec
const max_speed = 350

onready var shoot_ray = get_node("shoot_ray")

var acc = Vector2()
var vel = Vector2()
var rot = 0
var barrel_offset = Vector2(30, 10)

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		shoot()

func shoot():
	if shoot_ray.is_colliding():
		emit_signal("hit", get_pos() + barrel_offset.rotated(get_rot()),
				    shoot_ray.get_collision_point())

func _fixed_process(delta):
	# rotation
	rot = Input.is_action_pressed("ui_left") - Input.is_action_pressed("ui_right")
	rot *= rot_speed
	set_rot(get_rot() + rot * delta)
	# movement
	acc = Vector2()
	if Input.is_action_pressed("ui_up"):
		acc = Vector2(accel, 0).rotated(get_rot())
	elif Input.is_action_pressed("ui_down"):
		acc = Vector2(-accel / 4, 0).rotated(get_rot())
	else:
		acc = vel * friction * delta
	vel += acc * delta
	vel = vel.clamped(max_speed)
	var motion = move(vel * delta)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		vel = n.slide(vel)
		move(motion)
