extends Node2D

onready var info = get_node("info")
onready var map = get_node("map1")

func _ready():
	set_process_input(true)
	get_node("player").connect("hit", self, "_collided")

func _input(event):
	if event.is_action_pressed("mouse_lclick"):
		var mouse_pos = get_global_mouse_pos()
		var tile = map.world_to_map(mouse_pos)
		map.set_cellv(tile, -1)
		var text = "screen: %s\ntile: %s" % [mouse_pos, tile]
		info.set_text(text)

func _collided(pos):
	var tile = map.get_cellv(map.world_to_map(pos))
	if tile != -1:
		map.set_cellv(map.world_to_map(pos), 5)