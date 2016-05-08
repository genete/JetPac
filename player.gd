
extends KinematicBody2D


const GRAVITY = 200.0 # Pixels/second
const WALK_MAX_SPEED = 80
const ADDITIONAL_SPEED_ON_AIR = 20
const MAX_VERTICAL_SPEED=100
const THRESOLD=5
const SECONDS_BEFORE_REVIVE=3
const JET_FORCE = 250.0
const BOUNCE_FACTOR=50


var velocity = Vector2()
var shooting = false
var jetting=false

var prev_jump_pressed = false
var anim=""
var siding_left=false
var walk_left
var walk_right
var jet
var shot
var stop = true

var laser = preload("res://new_laser.tscn")
var explosion= preload("res://explosion.tscn")

var disabled=false
var counter=0
var destroyed=false

signal died


func _ready():
	set_fixed_process(true)
	PS2D.body_add_collision_exception(get_node("../Ship/body00").get_rid(), get_rid())
	PS2D.body_add_collision_exception(get_node("../Ship/body01").get_rid(), get_rid())
	PS2D.body_add_collision_exception(get_node("../Ship/body02").get_rid(), get_rid())
	prepare_player()
	add_user_signal("died")
	connect("died", get_node("/root/World"), "_callback_player_died")

func _fixed_process(delta):
	if destroyed:
		counter+=delta
		if counter>SECONDS_BEFORE_REVIVE:
			counter=0
			destroyed=false
			prepare_player()
			disable_player(false)
			show()
			get_node("/root/World").enable_enemies()

	# Create forces
	var force = Vector2(0, GRAVITY)
	var new_anim=anim
	var new_siding_left=siding_left
	if disabled:
		walk_left=false
		walk_right=false
		jet=false
		shot=false
		force=Vector2(0,0)
		velocity=Vector2(0,0)
	else:
		walk_left = Input.is_action_pressed("move_left")
		walk_right = Input.is_action_pressed("move_right")
		jet = Input.is_action_pressed("jet")
		shot=Input.is_action_pressed("shot")
		
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
		force=Vector2(0,-JET_FORCE)
		new_anim="flying"

	if jet and not jetting and velocity.y==0:
		var exp_instance=explosion.instance()
		get_parent().add_child(exp_instance)
		exp_instance.set_pos(get_pos()+Vector2(0, 12))
		exp_instance.get_node("anim").play("explode")


	# Integrate forces to velocity
	velocity += force*delta
	
	#Limit vertical speed
	if velocity.y < -MAX_VERTICAL_SPEED:
		velocity.y=-MAX_VERTICAL_SPEED
	elif velocity.y > MAX_VERTICAL_SPEED:
		velocity.y=MAX_VERTICAL_SPEED

		# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	if(is_colliding()):
		var obj=get_collider()
		if obj.is_in_group("enemies"):
			destroy(true)
		var n=get_collision_normal()
		motion=n.slide(motion)
		velocity=n.slide(velocity)
		move(motion)
		if n.dot(Vector2(0,-1)) < 0 and obj.get_name()!="roof":
			velocity=BOUNCE_FACTOR*n
			


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
		if not has_node("body01"):
			PS2D.body_add_collision_exception(li, get_node("../Ship/body01").get_rid())
		else:
			PS2D.body_add_collision_exception(li, get_node("body01").get_rid())
		
		if not has_node("body02"):
			PS2D.body_add_collision_exception(li, get_node("../Ship/body02").get_rid())
		else:
			PS2D.body_add_collision_exception(li, get_node("body02").get_rid())
	
	jetting=jet
	shooting=shot
	
	# Handle left and right screen limits 
	var pos=get_pos()
	var right_limit=256-THRESOLD
	var left_limit=THRESOLD
	if walk_left and pos.x <= left_limit:
		print("viewport.pos.x=", get_viewport_rect().pos.x)
		print("left_limit=", left_limit)
		print("walk left and pos.x=", pos.x)
		set_pos(Vector2(right_limit, pos.y))
	elif walk_right and pos.x >=right_limit:
		print("viewport.end.x=", get_viewport_rect().end.x)
		print("right_limit=", right_limit)
		print("walk right and pos.x=", pos.x)
		set_pos(Vector2(left_limit, pos.y))

func prepare_player():
	set_pos(get_node("../Player_pos").get_pos())

func disable_player(var b):
	print("disable player ", b)
	disabled=b
	get_node("CollisionShape2D").set_trigger(b)

func destroy(var animate):
	var count=get_child_count()
	var children=get_children()
	var ship=get_node("/root/World/Ship")
	for i in range(0, count):
		if children[i].is_in_group("attached"):
			var pos=children[i].get_pos()
			remove_child(children[i])
			ship.add_child(children[i])
			children[i].set_pos(get_pos()+pos)
			if children[i].has_method("start_gravity"):
				children[i].start_gravity()
			children[i].show()
	destroyed=true
	emit_signal("died")
	disable_player(true)
	var exp_instance=explosion.instance()
	get_parent().add_child(exp_instance)
	exp_instance.set_pos(get_pos())
	exp_instance.get_node("anim").play("explode")
	hide()
	get_node("/root/World").disable_enemies()
	get_node("/root/World").destroy_enemies()
	
