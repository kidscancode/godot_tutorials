# KinematicBody2D Collision demo
# KidsCanCode 2017

extends KinematicBody2D

var vel = Vector2()
var speed = 350  # pixels/sec

# set this to < 1.0 to demonstrate loss of energy
var bounce_coefficent = 1.0

func _ready():
	randomize()
	# start at center of screen
	set_pos(OS.get_window_size() / 2)
	# start in a random direction
	vel = Vector2(speed, 0).rotated(rand_range(0, 2*PI))
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	# spacebar toggles vector display
	if event.is_action_pressed("ui_select"):
		var dbug = get_node("debug_draw")
		dbug.set_hidden(not dbug.is_visible())

func _fixed_process(delta):
	# uncomment to demonstrate gravity
	# vel.y += 1000 * delta
	var motion = move(vel * delta)
	if is_colliding():
		var n = get_collision_normal()
		motion = n.reflect(motion)
		vel = n.reflect(vel) * bounce_coefficent
		move(motion)