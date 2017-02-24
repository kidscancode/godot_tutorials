extends Area2D

var vel = Vector2()
export var speed = 1000

func _ready():
	set_fixed_process(true)

func start_at(dir, pos, v):
	set_rot(dir)
	set_pos(pos)
	vel = v + Vector2(speed, 0).rotated(dir + PI/2)

func _fixed_process(delta):
	set_pos(get_pos() + vel * delta)

func _on_lifetime_timeout():
	queue_free()
