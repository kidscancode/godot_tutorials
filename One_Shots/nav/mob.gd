extends Sprite

var speed = 150
var nav = null setget set_nav
var path = []
var goal = Vector2()

func _ready():
	set_fixed_process(true)

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	path = nav.get_simple_path(get_pos(), goal, false)
	if path.size() == 0:
		queue_free()

func _fixed_process(delta):
	if path.size() > 1:
		var d = get_pos().distance_to(path[0])
		if d > 2:
			set_pos(get_pos().linear_interpolate(path[0], (speed * delta)/d))
		else:
			path.remove(0)
	else:
		queue_free()
