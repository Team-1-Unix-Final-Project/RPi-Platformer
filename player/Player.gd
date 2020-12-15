extends KinematicBody2D

var ACCEL = 20
var JUMP_TIME = 12
var JUMP_STRENGTH = 100
var FRICTION = 0.3
var SPRINT_MULTIPLIER = 1.5
var MAX_WALKSPEED = 200
var MAX_SPRINTSPEED = MAX_WALKSPEED * SPRINT_MULTIPLIER
var GRAV_ACCEL = 30
var MAX_GRAV = 400
var FIRE_RATE = 0.5

var current_accel = 0
var vel = Vector2.ZERO
var dir = Vector2.ZERO
var sprint_dir = 0
var current_jump_time = 0

var state = "idle"
var sts = {"idle":"idle","walk":"walking","sprint":"sprinting","jump":"jumping","fall":"falling","shoot":"shooting"}
var sprint = false
var shot = false
var shooting = false

#------------------------------ ON INSTANCE -----------------------------------#
func _ready():
	global.player = self
	$FireRateTimer.set_wait_time(FIRE_RATE)

#---------------------- FOR EVERY INGAME PROCESS CYCLE ------------------------#
func _physics_process(_delta):
	################################ WASD INPUT ################################
	
	if Input.is_action_pressed("left"):
		$AnimatedSprite.scale.x = -1
		if state == sts.idle && state != sts.walk:
			set_state(sts.walk)
		dir.x -= 1
	if Input.is_action_pressed("right"):
		$AnimatedSprite.scale.x = 1
		if state == sts.idle && state != sts.walk:
			set_state(sts.walk)
		dir.x += 1
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right") || Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		dir.x = 0
	if Input.is_action_pressed("down"):
		#TODO: Sliding stuff 
		pass
	
	################################ JUMPING ###################################
	if Input.is_action_just_pressed("jump") && is_on_floor():
		set_state(sts.jump)
	if Input.is_action_pressed("jump") && state == sts.jump:
		if current_jump_time < JUMP_TIME:
			dir.y = -1
			vel.y += dir.y * JUMP_STRENGTH
			vel.y = clamp(vel.y,-MAX_GRAV,MAX_GRAV)
			current_jump_time += 1
		else:
			current_jump_time = 0
			if state != sts.fall:
				set_state(sts.fall)
	if Input.is_action_just_released("jump") && state == sts.jump || state == sts.jump && is_on_ceiling():
		current_jump_time = 0
		if state != sts.fall:
			set_state(sts.fall)
	
	################################ SPRINTING #################################
	if !sprint:
		if Input.is_action_just_pressed("left") && !Input.is_action_pressed("right"):
				if round(vel.x) > 0:
					sprint_dir = -1
				elif sprint_dir > -2:
					sprint_dir -= 1
				$SprintTimer.start()
		if Input.is_action_just_pressed("right") && !Input.is_action_pressed("left"):
				if round(vel.x) < 0:
					sprint_dir = 1
				elif sprint_dir < 2:
					sprint_dir += 1
				$SprintTimer.start()
	#Set sprint
	if abs(sprint_dir) == 2:
		if !sprint:
			sprint = true
		sprint_dir = 0
	
	################################ SHOOTING ##################################
	if Input.is_action_pressed("shoot"):
		shooting = true
		$ShootingStateTimer.start()
		if shot == false:
			shoot()
			shot = true
			$FireRateTimer.start()
	
	################################ FRICTION AND ACCEL ########################
	if dir.x == 0:
		vel.x = lerp(vel.x,0,FRICTION)
	else:
		if sprint:
			current_accel = ACCEL * SPRINT_MULTIPLIER
		else:
			current_accel = ACCEL
		vel.x = dir.x * current_accel
	
	################################ MIN / MAX VEL #############################
	if sprint:
		vel.x = clamp(vel.x,-MAX_SPRINTSPEED,MAX_SPRINTSPEED)
	else:
		vel.x = clamp(vel.x,-MAX_WALKSPEED,MAX_WALKSPEED)
	
	################################ GRAVITY ###################################
	dir.y = 1
	if state != sts.jump:
		vel.y += dir.y * GRAV_ACCEL
		vel.y = clamp(vel.y, -MAX_GRAV, MAX_GRAV)
	
	################################ MOVE AND SLIDE ############################
	vel = move_and_slide(vel,Vector2.UP)
	
	################################ STATE CHECKS ##############################
	#Change to idle if on floor and not moving
	if round(dir.x) == 0 && is_on_floor():
		sprint = false
		if state != sts.idle:
			set_state(sts.idle)
	#Change to walking if on floor and moving
	elif round(dir.x) != 0 && is_on_floor():
		if state != sts.walk && state != sts.sprint:
			set_state(sts.walk)
	#Change to falling if not on floor
	elif !is_on_floor() && state != sts.jump:
		if state != sts.fall:
			set_state(sts.fall)

	################################ ANIMATIONS ################################
	play_animation()

#------------------------------------ FUNCTIONS -------------------------------#
func set_state(new_state : String):
	state = new_state

func shoot():
	var loadShot = load("res://projectiles/Blast.tscn")
	var instance = loadShot.instance()
	instance.global_position = $AnimatedSprite/ShotPosition.global_position
	instance.scale = $AnimatedSprite.scale
	instance.set_hit_points(1)
	instance.set_speed(1)
	get_tree().get_root().add_child(instance)

func play_animation():
	if shooting:
		if state == sts.walk || state == sts.sprint:
			$AnimatedSprite.play("runshoot")
		elif state == sts.jump || state == sts.fall:
			$AnimatedSprite.play("jumpshoot")
		elif state == sts.idle:
			$AnimatedSprite.play("shoot")
		else:
			$AnimatedSprite.play("shoot")
	else:
		if state == sts.walk || state == sts.sprint:
			$AnimatedSprite.play("run")
		elif state == sts.jump:
			$AnimatedSprite.play("jump")
		elif state == sts.fall:
			$AnimatedSprite.play("fall")
		elif state == sts.idle:
			$AnimatedSprite.play("default")
		else:
			$AnimatedSprite.play("default")

#---------------------------- SIGNAL CONNECTIONS ------------------------------#
func _on_SprintTimer_timeout():
	sprint_dir = 0

func _on_FireRateTimer_timeout():
	shot = false

func _on_ShootingStateTimer_timeout():
	shooting = false
