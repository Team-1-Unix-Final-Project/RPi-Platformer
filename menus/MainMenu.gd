extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gamescene = load("res://levels/Level1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if $Button.connect("pressed",self,"start"):
		print("Could not connect main menu to start button")
	if $Button2.connect("pressed",self,"quit"):
		print("Could not connect main menu to quit button")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	if get_tree().change_scene_to(gamescene):
		print("ERROR: could not load gamescene")

func quit():
	if get_tree().quit():
		print("ERROR: could not call get_tree.quit()")