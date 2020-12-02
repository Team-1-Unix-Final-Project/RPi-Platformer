extends Sprite

var pos

func _init():
	pos = position

func _physics_process(delta):
	var vel = global.player.vel
	if round(vel.x) > 0:
		position.x -= lerp(0,vel.x/10,0.1)/10
	elif round(vel.x) < 0:
		position.x -= lerp(0,vel.x/10,0.1)/10