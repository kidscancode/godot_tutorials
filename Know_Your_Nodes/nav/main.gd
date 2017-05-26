extends Node

var mob = preload("res://mob.tscn")

onready var start_pos = get_node("start_pos").get_pos()
onready var end_pos = get_node("end_pos").get_pos()
onready var map = get_node("map")

func _ready():
	set_process_input(true)


func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		var tile = event.pos / map.get_cell_size()
		if event.button_index == 1:
			map.set_cell(int(tile.x), int(tile.y), 30)
		elif event.button_index == 2:
			map.set_cell(int(tile.x), int(tile.y), 4)


func _on_mob_timer_timeout():
	var m = mob.instance()
	add_child(m)
	m.set_pos(start_pos)
	m.goal = end_pos
	m.nav = get_node("nav")
