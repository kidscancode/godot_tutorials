extends KinematicBody2D

const ACCEL = 1500
const MAX_SPEED = 500
const FRICTION = -500
const GRAVITY = 2000

var acc = Vector2()
var vel = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	print(delta)
	acc.y = GRAVITY
	acc.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	acc.x *= ACCEL
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta
	vel += acc * delta
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)

	var motion = move(vel * delta)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		vel = n.slide(vel)
		move(motion)
