# KinematicBody2D Collision demo
# KidsCanCode 2017

extends KinematicBody2D

var speed = 200
var vel = Vector2() # pixels/sec

# set this to < 1.0 to demonstrate loss of energy
var bounce_coefficent = 1.0
# this toggles reflect or slide mode
var reflect = true

func _ready():
	randomize()
	# set start velocity towards mouse position
	vel = (get_global_mouse_pos() - get_pos()).normalized() * speed
	set_fixed_process(true)

func _fixed_process(delta):
	# move the body
	var motion = move(vel * delta)
	if is_colliding():
		# find the normal
		var n = get_collision_normal()
		if reflect:
			# reflect the motion *and* the velocity
			motion = n.reflect(motion)
			vel = n.reflect(vel) * bounce_coefficent
		else:
			# or slide them
			motion = n.slide(motion)
			vel = n.slide(vel)
		# remember to also move the resulting motion amount
		move(motion)

func _on_visible_exit_screen():
	queue_free()
