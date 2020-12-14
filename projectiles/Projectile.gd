extends KinematicBody2D

var hit_points setget set_hit_points, get_hit_points
var speed setget set_speed, get_speed
var default_speed = 450
var current_speed = default_speed

####################### FOR EVERY INGAME PROCESS CYCLE #########################
func _physics_process(delta):
	#------------------------------- MOVE AND SLIDE ---------------------------#
	if scale.x < 0:
		current_speed *= -1
	move_and_slide(Vector2(current_speed * speed,0),Vector2.UP)
	#--------------------------- DESTROY ON COLLIDE ---------------------------#
	if get_slide_count():
		for count in get_slide_count():
			if not "Blast" in get_slide_collision(count).get_collider().name:
#				print("Body entered body...")
				queue_free()

############################# SETTERS AND GETTERS ##############################
func set_hit_points(value : int):
	hit_points = value

func get_hit_points():
	return hit_points

func set_speed(value : float):
	speed = value

func get_speed():
	return speed

############################## SIGNAL CONNECTIONS ##############################
func _on_AttackArea_body_entered(body):
	if body.has_method("deal_damage"):
		body.deal_damage(hit_points)
	elif not "Blast" in body.name:
#		print("Body entered area...")
		queue_free()
