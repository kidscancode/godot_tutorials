extends KinematicBody2D

onready var ground_ray = get_node("ground_ray")
onready var sprite = get_node("sprite")

const ACCEL = 1500
const MAX_SPEED = 500
const FRICTION = -500
const GRAVITY = 4000
const JUMP_SPEED = -1400
const MIN_JUMP = -500

var acc = Vector2()
var vel = Vector2()
var anim = "idle"

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_up") and ground_ray.is_colliding():
		vel.y = JUMP_SPEED
	if event.is_action_released("ui_up"):
		vel.y = clamp(vel.y, MIN_JUMP, vel.y)

func _fixed_process(delta):
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
	if abs(vel.x) < 10:
		vel.x = 0

	# set animation
	if vel.x == 0:
		anim = "idle"
	else:
		anim = "running"
	if vel.x > 0:
		sprite.set_flip_h(false)
	elif vel.x < 0:
		sprite.set_flip_h(true)
	sprite.play(anim)
