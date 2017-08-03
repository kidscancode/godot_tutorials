extends Node2D

onready var map = get_node("map1")

func _ready():
	var set = map.get_tileset()
	#map.set_cell(2, 8, -1)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		print(map.world_to_map(get_global_mouse_pos()))

