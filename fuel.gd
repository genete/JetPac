
extends KinematicBody2D

const GRAVITY = 50.0 
var velocity = Vector2()
var gravity

func _ready():
	randomize()
	set_fixed_process(true)
	start_gravity()
	set_pos(Vector2(randf()*get_viewport_rect().size.x, -20))
	get_node("fuel_sprite").set_modulate(Color(192.0/255, 0, 192.0/255, 1))


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
	if not get_parent().get_name()=="Player":
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