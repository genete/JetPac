
extends KinematicBody2D

# This is a simple collision demo showing how
# the kinematic controller works.
# move() will allow to move the node, and will
# always move it to a non-colliding spot,
# as long as it starts from a non-colliding spot too.

# Member variables
const GRAVITY = 90.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 200
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	move(Vector2(0,1))
#	# Create forces
#	var force = Vector2(0, GRAVITY)
#	
#	var walk_left = Input.is_action_pressed("move_left")
#	var walk_right = Input.is_action_pressed("move_right")
#	var jump = Input.is_action_pressed("jump")
#	
#	var stop = true
#	
#	if (walk_left):
#		velocity.x=-WALK_MAX_SPEED
#	elif (walk_right):
#		velocity.x=WALK_MAX_SPEED
#	else:
#		velocity.x=0
#	
#	# Integrate forces to velocity
#	velocity += force*delta
#	
#	# Integrate velocity into motion and move
#	var motion = velocity*delta
#	
#	# Move and consume motion
#	motion = move(motion)
#	if(is_colliding()):
#		var n=get_collision_normal()
#		motion=n.slide(motion)
#		velocity=n.slide(velocity)
#		move(motion)
