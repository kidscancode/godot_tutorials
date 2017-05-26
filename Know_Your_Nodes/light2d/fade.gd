extends Area2D

func _ready():
	print("loaded")
	connect("body_enter", self, "_on_Area2D_body_enter")
	connect("body_exit", self, "_on_Area2D_body_exit")


func _on_Area2D_body_enter( body ):
	print("enter")
	get_parent().set_opacity(0.5)


func _on_Area2D_body_exit( body ):
	print('exit')
	get_parent().set_opacity(1.0)
