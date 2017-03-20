extends Node

onready var trans = get_node("trans")
onready var ease_option = get_node("ease")
onready var sprite = get_node("Sprite")
onready var tween = get_node("Tween")

var trans_list = ['TRANS_LINEAR', 'TRANS_SINE', 'TRANS_QUINT',
                  'TRANS_QUART', 'TRANS_QUAD', 'TRANS_EXPO',
				  'TRANS_ELASTIC', 'TRANS_CUBIC', 'TRANS_CIRC',
				  'TRANS_BOUNCE']
var ease_list = ['EASE_IN', 'EASE_OUT', 'EASE_IN_OUT', 'EASE_OUT_IN']

var trans_current = 0
var ease_current = 0
var start_pos = Vector2(50, 500)
var end_pos = Vector2(950, 50)

func _ready():
	for item in trans_list:
		trans.add_item(item)
	for item in ease_list:
		ease_option.add_item(item)
	set_process(true)

func _process(delta):
	pass

func run_animation():
	sprite.set_pos(start_pos)
	tween.interpolate_property(sprite, 'transform/pos', start_pos, end_pos, 5, trans_current, ease_current)
	tween.start()

func _on_trans_item_selected( ID ):
	trans_current = ID
	run_animation()

func _on_ease_item_selected( ID ):
	ease_current = ID
	run_animation()

func _on_Tween_tween_complete( object, key ):
	#run_animation()
	pass