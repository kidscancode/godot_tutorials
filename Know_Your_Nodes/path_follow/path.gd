extends Path2D

onready var follow = get_node("follow")

var tween

func _ready():
	set_process(true)
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(follow, "unit_offset",
								0, 1, 6,
								tween.TRANS_SINE,
								tween.EASE_IN_OUT)
	tween.set_repeat(true)
	tween.start()

func _process(delta):
	#follow.set_offset(follow.get_offset() + 350 * delta)
	pass