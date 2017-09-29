extends Area2D

signal explode
signal shoot

export (PackedScene) var bullet

var follow
var target = null
var health = global.enemy_health
var pulse_timer

func _ready():
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	$ShootTimer.wait_time = 1.5 # TODO: vary by level
	$ShootTimer.start()
	
func _process(delta):
	follow.set_offset(follow.get_offset() + global.enemy_speed * delta)
	position = follow.global_position
	if follow.get_unit_offset() > 1:
		queue_free()
	
func take_damage(amount):
	$HitSound.play()
	health -= amount
	$AnimationPlayer.play("hit")
	if health <= 0:
		emit_signal("explode", global_position)
		queue_free()
		
func shoot1():
	var dir = (target.global_position - global_position).rotated(rand_range(-global.enemy_accuracy, global.enemy_accuracy))
	$LaserSound.play()
	emit_signal("shoot", bullet, global_position, dir.angle())
	
func _on_ShootTimer_timeout():
	if target.is_visible():
		shoot_pulse(3, 0.1)
		
func shoot_pulse(n, delay):
	for i in range(n):
		shoot1()
		pulse_delay(delay)
		yield($PulseTimer, "timeout")

func pulse_delay(delay):
	$PulseTimer.wait_time = delay
	$PulseTimer.process_mode = 0
	$PulseTimer.start()
