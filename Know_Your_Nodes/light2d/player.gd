extends KinematicBody2D

var jump_speed = -1000
var speed = 250
var gravity = 2000
var vel = Vector2()

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_up"):
		vel.y = jump_speed

func _fixed_process(delta):
	vel.y += gravity * delta
	vel.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	vel.x *= speed
	var motion = move(vel * delta)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		vel = n.slide(vel)
		move(motion)

