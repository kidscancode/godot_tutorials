extends KinematicBody2D

const floor_check = Vector2( 0, 1 )
const normal_check = Vector2( 0, -1 )
var angle_threshold  = PI/3 setget set_angle_threshold
onready var slope_scale = tan(angle_threshold)

func is_on_floor(): 
	return test_move(floor_check)

func set_angle_threshold(val): 
	angle_threshold = val
	slope_scale = tan(angle_threshold)
	
# A safe method for moving you vertically
func move_vertical(move_y):
	var motion = Vector2(0, move_y)
	if motion.y < 0 :
		var over = move(motion)
		if is_colliding() :
			var n = get_collision_normal()
			over = n.slide(over)
			move(over)
	if is_colliding():
		move(motion)
		if is_colliding(): 
			revert_motion()
	else: 
		move(motion)
	return is_colliding()

# Method which will move you horizontally and even up slopes
func move_horizontal(move_x):
	var motion = Vector2(move_x, 0)
	var was_on_floor = is_on_floor()
	var over = move(motion)
	if is_colliding():
		var n = get_collision_normal()
		var angle = acos(n.dot(normal_check))
		if angle < angle_threshold: 
			over = n.slide(over)
			move(over)
			if !test_move(floor_check):
				var max_move = Vector2(0, -get_travel().y) 
				if test_move(max_move): 
					move_vertical(max_move.y)
		else: 
			revert_motion() 
			
	elif was_on_floor:
		if not test_move(floor_check):
			var max_move = Vector2(0, get_travel().abs().x)# * slope_scale)
			if test_move(max_move):
				move_vertical(max_move.y)
