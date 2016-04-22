
extends KinematicBody2D

const GRAVITY = 100.0 
var velocity = Vector2()
var gravity
var first_time=true

func _ready():
	set_fixed_process(true)
	start_gravity()

func _fixed_process(delta):
	var force = Vector2(0, gravity)
	velocity += force*delta
	var motion = velocity*delta

	motion = move(motion)
	
	if(is_colliding()):
		var n=get_collision_normal()
		motion=n.slide(motion)
		velocity=n.slide(velocity)
		move(motion)


func stop_gravity():
	gravity=0

func start_gravity():
	gravity=GRAVITY