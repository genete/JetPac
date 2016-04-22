
extends KinematicBody2D

# This is a simple collision demo showing how
# the kinematic controller works.
# move() will allow to move the node, and will
# always move it to a non-colliding spot,
# as long as it starts from a non-colliding spot too.

# Member variables
const GRAVITY = 400.0 # Pixels/second
const WALK_MAX_SPEED = 80
const ADDITIONAL_SPEED_ON_AIR = 20
const MAX_VERTICAL_SPEED=140
const THRESOLD=5

var velocity = Vector2()
var shooting = false
var jet_force = 650.0

var prev_jump_pressed = false
var anim=""
var siding_left=false

var laser = preload("res://new_laser.tscn")


func _ready():
	set_fixed_process(true)
	PS2D.body_add_collision_exception(get_node("../Ship/body00").get_rid(), get_rid())
	PS2D.body_add_collision_exception(get_node("../Ship/body01").get_rid(), get_rid())
	PS2D.body_add_collision_exception(get_node("../Ship/body02").get_rid(), get_rid())

func _fixed_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	var new_anim=anim
	var new_siding_left=siding_left
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jet = Input.is_action_pressed("jet")
	var shot=Input.is_action_pressed("shot")
	
	var stop = true
	
	if (walk_left):
		velocity.x=-WALK_MAX_SPEED
		if(jet):
			velocity.x-=ADDITIONAL_SPEED_ON_AIR
		new_siding_left=true
		new_anim="walk"
	elif (walk_right):
		velocity.x=WALK_MAX_SPEED
		if(jet):
			velocity.x+=ADDITIONAL_SPEED_ON_AIR
		new_siding_left=false
		new_anim="walk"
	else:
		velocity.x=0
		new_anim="idle"
	if (jet):
		force=Vector2(0,-jet_force)
		new_anim="flying"

		# Integrate forces to velocity
	velocity += force*delta
	
	#Limit vertical speed
	if velocity.y < -MAX_VERTICAL_SPEED:
		velocity.y=-MAX_VERTICAL_SPEED

		# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	if(is_colliding()):
		var obj=get_collider()
		var n=get_collision_normal()
		motion=n.slide(motion)
		velocity=n.slide(velocity)
		move(motion)

		# Update siding
	if (new_siding_left != siding_left):
		if (new_siding_left):
			get_node("Sprite").set_scale(Vector2(-1, 1))
		else:
			get_node("Sprite").set_scale(Vector2(1, 1))
		siding_left = new_siding_left

	# Change animation
	if (new_anim != anim):
		anim = new_anim
		get_node("Sprite/anim").play(anim)
	
	# Add laser instance
	if shot and not shooting:
		var li=laser.instance()
		var lpos=get_node("Sprite/laser_pos").get_pos()
		var pos = get_pos()+lpos
		if(siding_left):
			li.invert_direction()
			pos = pos-Vector2(2*lpos.x,0)
		li.set_pos(pos)
		get_parent().add_child(li)
		PS2D.body_add_collision_exception(li, get_rid())
		PS2D.body_add_collision_exception(li, get_node("../Ship/body00").get_rid())
		PS2D.body_add_collision_exception(li, get_node("../Ship/body01").get_rid())
		PS2D.body_add_collision_exception(li, get_node("../Ship/body02").get_rid())
	
	shooting=shot
	
	var pos=get_pos()
	var right_limit=get_viewport_rect().end.x-THRESOLD
	var left_limit=get_viewport_rect().pos.x+THRESOLD
	if walk_left and pos.x <= left_limit:
		set_pos(Vector2(right_limit, pos.y))
	elif walk_right and pos.x >=right_limit:
		set_pos(Vector2(left_limit, pos.y))

