extends CanvasLayer

func _input(event):
	pass
	# pause code
	
func update_score(val):
	$ScoreLabel.text = str(val)
	
func update_shield(val):
	if val <= 0:
		$ShieldIcon.modulate = Color(1, 1, 1, 0.5)
	var color = 'green'
	if val < 40:
		color = 'red'
	elif val < 70:
		color = 'yellow'
	var texture = load("res://art/gui/barHorizontal_%s_mid 200.png" % color)
	$ShieldBar.texture_progress = texture
	$ShieldBar.value = val
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	$MessageLabel.text = ''
