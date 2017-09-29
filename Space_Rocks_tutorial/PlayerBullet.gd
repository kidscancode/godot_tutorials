extends "res://Bullet.gd"

func _on_Visibility_screen_exited():
	queue_free()

func _on_PlayerBullet_body_entered( body ):
	if body.is_in_group("asteroids"):
		queue_free()
		body.explode(velocity.normalized())

func _on_PlayerBullet_area_entered( area ):
	if area.is_in_group("enemies"):
		queue_free()
		area.take_damage(global.bullet_damage)