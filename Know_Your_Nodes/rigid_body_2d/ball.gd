extends RigidBody2D

func _ready():
	set_process_input(true)

func _input(event):
	pass

func _on_ball_input_event( viewport, event, shape_idx ):
	#print(event.type)
	if event.type == InputEvent.MOUSE_BUTTON:
		var off = get_local_mouse_pos() * 100
		print(off)
		#apply_impulse(off, Vector2(rand_range(-200, 200), -400))
		apply_impulse(off, Vector2(0, -400))
		#set_linear_velocity(Vector2(rand_range(-200, 200), -400))
