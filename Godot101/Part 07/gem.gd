extends Area2D

signal gem_grabbed

func _ready():
	pass

func _on_gem_area_enter( area ):
	if area.get_name() == "player":
		emit_signal("gem_grabbed")
		queue_free()
