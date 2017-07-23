extends Node

onready var sprite = preload("res://Sprite.tscn")

func _ready():
	for i in range(150):
		var s = sprite.instance()
		add_child(s)