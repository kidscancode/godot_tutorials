extends Sprite

var vel = Vector2(100, 50)

func _ready():
	print(get_pos())
	set_process(true)

func _process(delta):
	set_rot(get_rot() + PI * delta)
	set_pos(get_pos() + vel * delta)