#GEM 2
extends KinematicBody2D

const GRAVITY = 50.0 
var velocity = Vector2()
var gravity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1), 8:Color(1,1,1,1) }
var current_color=1
var timer=0
const TIME_OUT=0.15

func _ready():
	randomize()
	set_fixed_process(true)
	start_gravity()
	add_collision_exception_with(get_node("/root/World/roof"))
	set_pos(Vector2(randf()*256, -20))
	var enemies=get_node("/root/World/Enemies")
	var children=enemies.get_child_count()
	add_collision_exception_with(get_node("/root/World/Player"))
	add_collision_exception_with(get_node("/root/World/Ship/body00"))
	add_collision_exception_with(get_node("/root/World/Ship/body01"))
	add_collision_exception_with(get_node("/root/World/Ship/body02"))
	add_collision_exception_with(get_node("/root/World/Ship/Fuel"))

	

func _fixed_process(delta):
	var force = Vector2(0, gravity)
	velocity += force*delta
	var motion = velocity*delta

	motion = move(motion)
	
	if(is_colliding()):
		var n=get_collision_normal()
		motion=n.slide(motion)
		velocity=n.slide(velocity)
		if(velocity.x==0 and velocity.y==0):
			stop_gravity()
		move(motion)
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))



func stop_gravity():
	gravity=0

func start_gravity():
	gravity=GRAVITY

func get_points():
	return 250