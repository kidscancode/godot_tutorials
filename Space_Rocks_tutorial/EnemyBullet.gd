extends "res://Bullet.gd"

func _on_Visibility_screen_exited():
	queue_free()

func _on_EnemyBullet_area_entered( area ):
	if area.has_method("take_damage") and not area.is_in_group("enemies"):
		queue_free()
		area.take_damage(global.enemy_bullet_damage)
