extends Node

onready var gem = preload("res://gem.tscn")
onready var gem_container = get_node("gem_container")
onready var score_label = get_node("HUD/score_label")
onready var time_label = get_node("HUD/time_label")
onready var go_label = get_node("HUD/game_over_label")
onready var game_timer = get_node("game_timer")

var screensize
var score = 0
var level = 1

func _ready():
	randomize()
	screensize = get_viewport().get_rect().size
	set_process(true)
	spawn_gems(10)
	go_label.set_hidden(true)

func _process(delta):
	time_label.set_text(str(int(game_timer.get_time_left())))
	if gem_container.get_child_count() == 0:
		level += 1
		game_timer.set_wait_time(game_timer.get_time_left() + 10.0)
		game_timer.start()
		spawn_gems(level * 10)

func spawn_gems(num):
	for i in range(num):
		var g = gem.instance()
		gem_container.add_child(g)
		g.connect("gem_grabbed", self, "_on_gem_grabbed")
		g.set_pos(Vector2(rand_range(40, screensize.width-40),
		                  rand_range(40, screensize.height-40)))

func _on_gem_grabbed():
	score += 10
	score_label.set_text(str(score))

func _on_game_timer_timeout():
	go_label.set_hidden(false)
	get_node("player").set_process(false)
