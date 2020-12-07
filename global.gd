extends Node

var player

signal paused(value)
signal setHealth(value)

func _init():
	player = null
	emit_signal("paused",false)
	emit_signal("setHealth",10)

