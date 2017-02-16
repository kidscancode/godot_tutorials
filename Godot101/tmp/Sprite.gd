extends Sprite

var vel = Vector2(100, 50)

func _ready():
	print(get_pos())
	set_process(true)

func _process(delta):
	set_pos(get_pos() + vel * delta)
	set_scale(get_scale() - Vector2(0.2, 0.2) * delta)