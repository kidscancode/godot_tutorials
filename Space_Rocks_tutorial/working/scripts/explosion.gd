extends AnimatedSprite

func _on_explosion_finished():
	queue_free()
