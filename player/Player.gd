extends KinematicBody2D

const ACCEL = 20
const JUMP_TIME = 10
const JUMP_STRENGTH = 100
const FRICTION = 0.2
const MAX_WALKSPEED = 200
const MAX_SPRINTSPEED = 400
const GRAV_ACCEL = 30
const MAX_GRAV = 400

var current_accel = 0
var vel = Vector2.ZERO
var dir = Vector2.ZERO
var sprint_dir = 0
var current_jump_time = 0

var state = "idle"
var sts = {"idle":"idle","walk":"walking","sprint":"sprinting","jump":"jumping","fall":"falling","wall_jump":"walljumping","slide":"sliding"}
var sprint = false

func _ready():
	global.player = self
	if $SprintTimer.connect("timeout",self,"sprint_timer") == 1:
		print("Error in "+self.name+" scene connecting "+$SprintTimer.name)

func _physics_process(_delta):
	################################ WASD INPUT ########################################
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
	
	################################ JUMP ########################################
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
	
	################################ SPRINTING ########################################
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
	
	################################ FRICTION AND ACCEL ########################################
	if dir.x == 0:
		vel.x = lerp(vel.x,0,FRICTION)
	else:
		if sprint:
			current_accel = ACCEL * 2
		else:
			current_accel = ACCEL
		vel.x = dir.x * current_accel
	
	################################ MIN / MAX VEL ########################################
	if sprint:
		vel.x = clamp(vel.x,-MAX_SPRINTSPEED,MAX_SPRINTSPEED)
	else:
		vel.x = clamp(vel.x,-MAX_WALKSPEED,MAX_WALKSPEED)
	
	################################ GRAVITY ########################################
	dir.y = 1
	if state != sts.jump:
		vel.y += dir.y * GRAV_ACCEL
		vel.y = clamp(vel.y, -MAX_GRAV, MAX_GRAV)
	
	################################ MOVE AND SLIDE ########################################
	vel = move_and_slide(vel,Vector2.UP)
	
	################################ STATE CHECKS ########################################
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
	
	################################ ANIMATIONS ########################################
	play_animation()

################################ FUNCTIONS ########################################
func set_state(new_state : String):
	#print("Stopped "+state+"...")
	#print("Started "+new_state+"...")
	state = new_state

func sprint_timer():
	sprint_dir = 0
	#print("Timer 0")

func play_animation():
	if state == sts.walk:
		$AnimatedSprite.play("run")
	elif state == sts.sprint:
		$AnimatedSprite.play("run")
	elif state == sts.jump:
		$AnimatedSprite.play("jump")
	elif state == sts.fall:
		$AnimatedSprite.play("fall")
	elif state == sts.idle:
		$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.play("default")