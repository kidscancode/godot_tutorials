extends RigidBody2D

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("mouse_click"):
		var dir = (get_global_mouse_pos() - get_pos()).normalized()
		apply_impulse(Vector2(), dir * 800)
