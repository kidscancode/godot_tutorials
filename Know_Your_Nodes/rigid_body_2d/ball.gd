extends RigidBody2D

func _ready():
	set_process_input(true)

func _input(event):
	pass

func _on_ball_input_event( viewport, event, shape_idx ):
	#print(event.type)
	if event.type == 3:
		set_linear_velocity(Vector2(rand_range(-200, 200), -400))
