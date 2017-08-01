extends "res://scripts/bullet.gd"

func _on_enemy_bullet_area_enter( area ):
	if area.has_method("damage") and not area.get_groups().has("enemies"):
		queue_free()
		area.damage(global.enemy_bullet_damage)
