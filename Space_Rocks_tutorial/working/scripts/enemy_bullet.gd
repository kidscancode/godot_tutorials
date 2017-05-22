extends Area2D

var vel = Vector2()
export var speed = 800

func _ready():
	set_fixed_process(true)

func start_at(dir, pos):
	set_rot(dir)
	set_pos(pos)
	vel = Vector2(speed, 0).rotated(dir + PI/2)

func _fixed_process(delta):
	set_pos(get_pos() + vel * delta)

func _on_visible_exit_screen():
	queue_free()
