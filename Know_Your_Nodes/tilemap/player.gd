extends "res://platformer_char.gd"

var gravity = 50
var walk_speed = 300
var jump_speed = -13
var vel = Vector2()

func _ready():
	self.angle_threshold = PI/3
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if is_on_floor() and event.is_action_pressed("ui_select"):
		vel.y = jump_speed

func _fixed_process(delta):
	vel.y += gravity * delta

	vel.x = Input.is_key_pressed(KEY_RIGHT) - Input.is_key_pressed(KEY_LEFT)
	vel.x *= walk_speed * delta
	move_horizontal(vel.x)
	if move_vertical(vel.y):
		vel.y = 0