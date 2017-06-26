# KinematicBody2D Collision demo
# KidsCanCode 2017

extends Node

onready var ball = preload("res://ball.tscn")
var reflect = true

func _ready():
	set_process_input(true)

func _input(event):
	# spawn a ball at start pos when mouse clicked and
	# set collision response mode to reflect/slide
	if event.is_action_pressed("mouse_click"):
		var b = ball.instance()
		b.set_pos(get_node("start").get_global_pos())
		b.reflect = reflect
		add_child(b)

	# toggle collision response mode
	if event.is_action_pressed("ui_select"):
		reflect = not reflect
		if reflect:
			get_node("mode").set_text("reflect")
		else:
			get_node("mode").set_text("slide")