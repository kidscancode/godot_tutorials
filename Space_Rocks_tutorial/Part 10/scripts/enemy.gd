extends Area2D

onready var paths = get_node("enemy_paths")

var path
var follow
var remote
var speed = 250

func _ready():
	set_process(true)
	randomize()
	path = paths.get_children()[randi() % paths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	remote = Node2D.new()
	follow.add_child(remote)

func _process(delta):
	follow.set_offset(follow.get_offset() + speed * delta)
	set_pos(remote.get_global_pos())

func _on_visible_exit_screen():
	queue_free()
