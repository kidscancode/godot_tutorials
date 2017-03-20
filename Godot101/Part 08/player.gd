extends Area2D

export var speed = 400

var screensize
var extents
var vel = Vector2()

func _ready():
	set_process(true)
	screensize = get_viewport_rect().size
	extents = get_node("collision").get_shape().get_extents()
	set_pos(screensize / 2)

func _process(delta):
	var input = Vector2(0, 0)
	input.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	input.y = Input.is_action_pressed("ui_down") - Input.is_action_pressed("ui_up")
	vel = input.normalized() * speed
	var pos = get_pos() + vel * delta
	pos.x = clamp(pos.x, extents.width, screensize.width - extents.width)
	pos.y = clamp(pos.y, extents.height, screensize.height - extents.height)
	set_pos(pos)
