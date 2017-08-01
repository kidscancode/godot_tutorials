extends "res://scripts/bullet.gd"

func _on_lifetime_timeout():
	queue_free()

func _on_player_bullet_body_enter( body ):
	if body.get_groups().has("asteroids"):
		queue_free()
		body.explode(vel.normalized())

func _on_player_bullet_area_enter( area ):
	if area.get_groups().has("enemies"):
		queue_free()
		area.damage(global.bullet_damage)
