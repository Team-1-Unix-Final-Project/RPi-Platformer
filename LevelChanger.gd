extends Node2D

export var changeTo : PackedScene
#export var onKill : int
#export var onCollect : int

var player_inside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if $Area2D.connect("body_entered",self,"player_in"):
		print("Could not connect "+name+" to area(bodyentered)")
	if $Area2D.connect("body_exited",self,"player_out"):
		print("Could not connect "+name+" to area(bodyexited)")

func _process(_delta):
	if Input.is_action_just_pressed("interact") && player_inside:
		if get_tree().change_scene_to(changeTo):
			print("Could not change scene from "+name)

func player_in(body):
	if body == global.player:
		player_inside = true

func player_out(body):
	if body == global.player:
		player_inside = false
