#GEM 3
extends KinematicBody2D

const GRAVITY = 50.0 
var velocity = Vector2()
var gravity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1), 8:Color(1,1,1,1) }
var current_color=1

func _ready():
	randomize()
	set_fixed_process(true)
	start_gravity()
	set_pos(Vector2(randf()*256, -20))


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