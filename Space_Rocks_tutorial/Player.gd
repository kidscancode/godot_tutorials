extends Area2D

signal explode
signal shoot
signal shield_changed

var rot_speed = global.rot_level[global.upgrade_level['rot_speed']]
var thrust = global.thrust_level[global.upgrade_level['thrust']]
var max_vel = 400
var friction = -0.65
export (PackedScene) var bullet

var velocity = Vector2()
var acceleration = Vector2()
var shield_up = true
var shield_level = 100
	
func _ready():
	$Shield.frame = 2
	
func _fixed_process(delta):
	if shield_up and shield_level < global.shield_max:
		shield_level = min(shield_level + global.shield_level[global.upgrade_level['shield_regen']] * delta,
						   global.shield_max)
		if shield_level < 40:
			$Shield.frame = 0
		elif shield_level < 70:
			$Shield.frame = 1
		else:
			$Shield.frame = 2
		emit_signal("shield_changed", shield_level)
		
	if Input.is_action_pressed("ui_select"):
		if $GunTimer.get_time_left() == 0:
			shoot()
	if Input.is_action_pressed("ui_left"):
		rotation -= rot_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rot_speed * delta
	if Input.is_action_pressed("ui_up"):
		acceleration = Vector2(thrust, 0).rotated(rotation)
		$Exhaust.show()
	else:
		acceleration = Vector2()
		$Exhaust.hide()
	
	acceleration += velocity * friction
	velocity += acceleration * delta
	velocity = velocity.clamped(max_vel)
	position += velocity * delta
	if position.x > global.screensize.x:
		position.x = 0
	if position.x < 0:
		position.x = global.screensize.x
	if position.y > global.screensize.y:
		position.y = 0
	if position.y < 0:
		position.y = global.screensize.y

func shoot():
	$GunTimer.start()
	$LaserSound.play()
	emit_signal("shoot", bullet, $Muzzle.global_position, rotation)
	
func disable():
	visible = false
	set_fixed_process(false)
	call_deferred("set_enable_monitoring", false)
	
func take_damage(amount):
	if shield_up:
		$HitSound.play()
		shield_level -= amount
		if shield_level <= 0 and shield_up:
			$ShieldDownSound.play()
			shield_up = false
			shield_level = 0
			$Shield.hide()
		emit_signal("shield_changed", shield_level)
	else:
		disable()
		emit_signal("explode")
		
func _on_Player_body_entered( body ):
	if not visible:
		return
	if body.is_in_group("asteroids"):
		body.explode(velocity.normalized())
		take_damage(global.rock_damage[body.size])
