extends Area2D

export var rot_speed = 2.6
export var thrust = 500
export var max_vel = 400
export var friction = 0.65

var screen_size = Vector2()
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_pos(pos)
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("player_left"):
		rot += rot_speed * delta	
	if Input.is_action_pressed("player_right"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("player_thrust"):
		acc = Vector2(thrust, 0).rotated(rot)
	else:
		acc = Vector2(0, 0)
	
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	if pos.x > screen_size.width:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.width
	if pos.y > screen_size.height:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.height
	set_pos(pos)
		
	set_rot(rot - PI/2)
