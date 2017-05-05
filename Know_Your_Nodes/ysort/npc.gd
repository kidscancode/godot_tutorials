extends KinematicBody2D

export(bool) var moving = true

onready var sprite = get_node("sprite")
onready var anim = get_node("animation")

var charlist = ['healer_f.png', 'healer_m.png',
				'mage_f.png', 'mage_m.png',
				'ninja_f.png', 'ninja_m.png',
				'ranger_f.png', 'ranger_m.png',
				'townfolk1_f.png', 'townfolk1_m.png']

var dirs = ['r', 'l', 'u', 'd']
var dir_vecs = {'r': Vector2(1, 0),
			    'l': Vector2(-1, 0),
                'd': Vector2(0, 1),
			    'u': Vector2(0, -1)}

var facing = 'd'
var speed = 55
var dir

func _ready():
	randomize()
	var tex = charlist[randi() % charlist.size()]
	tex = load("res://art/rpgsprites1/%s" % tex)
	sprite.set_texture(tex)
	facing = dirs[randi() % dirs.size()]
	anim.play(facing)
	dir = dir_vecs[facing]
	set_fixed_process(true)

func _fixed_process(delta):
	if not moving:
		anim.stop()
	if moving:
		var motion = move(dir * speed * delta)
		if is_colliding():
			var n = get_collision_normal()
			move(n.slide(motion))
			dir = n
			if n.x > 0:
				facing = 'r'
			if n.x < 0:
				facing = 'l'
			if n.y > 0:
				facing = 'd'
			if n.y < 0:
				facing = 'u'
			anim.play(facing)