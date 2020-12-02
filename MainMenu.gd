extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gamescene = load("res://GameScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed",self,"start")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start():
	get_tree().change_scene_to(gamescene)