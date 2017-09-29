extends Node

export (PackedScene) var Asteroid
export (PackedScene) var Explosion
export (PackedScene) var Enemy

func _ready():
	randomize()
	global.screensize = get_viewport().size
	$Music.play()
	start_next_level()
	
func start_next_level():
	global.level += 1
	$EnemyTimer.stop()
	$EnemyTimer.wait_time = rand_range(4, 7)
	$EnemyTimer.start()
	$HUD.show_message("Wave %s" % global.level)
	for i in range(global.level):
		$"AsteroidPath/PathLocation".set_offset(randi())
		spawn_asteroid('big', $"AsteroidPath/PathLocation".position, Vector2())

func _process(delta):
	if $Asteroids.get_child_count() == 0:
		start_next_level()
		
func add_bullet(bullet_type, pos, dir):
	var b = bullet_type.instance()
	b.start_at(pos, dir)
	$Bullets.add_child(b)

func spawn_asteroid(size, pos, vel):
	var a = Asteroid.instance()
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)
	$Asteroids.add_child(a)

func explode_asteroid(size, extents, pos, vel, hit_vel):
	global.score += global.rock_points[size]
	$HUD.update_score(global.score)
	var newsize = global.break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent() * max(extents.x/2, extents.y/2) * offset
			var newvel = hit_vel.tangent() * vel.length() * 1.2 * offset
			newvel = newvel.rotated(rand_range(-0.5, 0.5))
			spawn_asteroid(newsize, newpos, newvel)
	var expl = Explosion.instance()
	add_child(expl)
	expl.position = pos
	$"Sounds/AsteroidExplosion".play()
	expl.play()

func explode_player():
	var expl = Explosion.instance()
	add_child(expl)
	expl.position = $Player.position
	expl.scale = Vector2(1.5, 1.5)
	expl.animation = "sonic"
	expl.play()
	$HUD.show_message("Game Over")
	$RestartTimer.start()

func explode_enemy(pos):
	global.score += global.enemy_points
	$HUD.update_score(global.score)
	var expl = Explosion.instance()
	add_child(expl)
	expl.position = pos
	expl.scale = Vector2(0.8, 0.8)
	expl.animation = "sonic"
	$"Sounds/EnemyExplosion".play()
	expl.play()

func _on_EnemyTimer_timeout():
	var e = Enemy.instance()
	add_child(e)
	e.target = $Player
	e.connect("shoot", self, "add_bullet")
	e.connect("explode", self, "explode_enemy")
	$EnemyTimer.wait_time = rand_range(25, 40)
	$EnemyTimer.start()

func _on_RestartTimer_timeout():
	global.new_game()
