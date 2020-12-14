extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if $Button.connect("pressed",self,"quit"):
		print("Could not connect "+name+" to button")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func quit():
	if get_tree().quit():
		print("Could not use get_tree().quit()...")
