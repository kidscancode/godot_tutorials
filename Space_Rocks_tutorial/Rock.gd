extends RigidBody2D

signal explode

var textures = {'big': ['res://art/meteorGrey_big1.png',
						'res://art/meteorGrey_big3.png',
						'res://art/meteorGrey_big4.png'],
				'med': ['res://art/meteorGrey_med1.png',
						'res://art/meteorGrey_med2.png'],
				'sm': ['res://art/meteorGrey_small1.png',
					   'res://art/meteorGrey_small2.png'],
				'tiny': ['res://art/meteorGrey_tiny1.png',
						 'res://art/meteorGrey_tiny2.png']}
						
var size
var extents
var screensize

func init(init_size, init_pos, init_vel):
	size = init_size
	mass = global.rock_mass[size]
	if init_vel.length_squared() > 0:
		linear_velocity = init_vel
	else:
		linear_velocity = Vector2(rand_range(40, 90), 0).rotated(rand_range(0, 2*PI))
	angular_velocity = rand_range(-1.5, 1.5)
	var texture = load(textures[size][randi() % textures[size].size()])
	$Sprite.texture = texture
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	shape.radius = min(extents.x, extents.y)
	var o = create_shape_owner(self)
	shape_owner_add_shape(o, shape)
	position = init_pos

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		$Puff.global_position = state.get_contact_local_position(i)
		$Puff.emitting = true
		
func explode(hit_vel):
	emit_signal("explode", size, extents, position, linear_velocity, hit_vel)
	queue_free()