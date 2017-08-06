extends Node2D

onready var map = get_node("level 1")
onready var info = get_node("info")

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("mouse_lclick"):
		var mouse_pos = get_global_mouse_pos()
		var tile = map.world_to_map(mouse_pos)
		info.set_text(str(tile))

