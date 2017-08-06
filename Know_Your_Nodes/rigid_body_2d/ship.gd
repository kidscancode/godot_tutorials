extends RigidBody2D

onready var stats = get_parent().get_node("hud/stats")

var thrust = Vector2(0, 250)
var torque = 20000.0

func _integrate_forces(state):
	if stats:
		var text = "v: %s\nr: %s" % [get_linear_velocity().length(), get_angular_velocity()]
		stats.set_text(text)
	if Input.is_action_pressed("ui_up"):
		get_node("sprite/thrust").set_hidden(false)
		set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
	else:
		get_node("sprite/thrust").set_hidden(true)
		set_applied_force(state.get_total_gravity() + Vector2())
	var t = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	set_applied_torque(torque * t)
