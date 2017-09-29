extends Area2D

var velocity = Vector2()
var speed = 1000

func start_at(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)
	
func _fixed_process(delta):
	position += velocity * delta
	
func _on_Visibility_exit_screen():
	queue_free()