extends Sprite

var speed = 150
var nav = null setget set_nav
var path = []
var goal = Vector2()

func _ready():
	set_fixed_process(true)

func set_nav(new_nav):
	nav = new_nav
	path = nav.get_simple_path(get_pos(), goal, false)
	#print("nav: ", path)

func _fixed_process(delta):
	var d = get_pos().distance_to(path[0])
	if d > 1:
		set_pos(get_pos().linear_interpolate(path[0], (speed * delta)/d))
	else:
		path.remove(0)

func _on_visible_exit_screen():
	#print("gone")
	queue_free()
