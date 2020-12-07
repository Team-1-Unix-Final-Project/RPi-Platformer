extends Node2D

var left = false
var right = false
var jump = false
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if $Timer.connect("timeout",self,"hide_controls"):
		print("Could not connect level1 to timer")

func _physics_process(_delta):
	if Input.is_action_just_pressed("left"):
		left = true
	elif Input.is_action_just_pressed("right"):
		right = true
	elif Input.is_action_just_pressed("jump"):
		jump = true
	elif jump && left && right && !started:
		started = true
		$Timer.start()

func hide_controls():
	$Player/Controls.set_visible(false)