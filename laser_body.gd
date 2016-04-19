
extends KinematicBody2D

var velocity = 600
var velocity_sign 

func _ready():
	set_fixed_process(true)
	velocity_sign=velocity/abs(velocity)

func _fixed_process(delta):
	var motion=Vector2(velocity, 0)*delta
	move(motion)
	if is_colliding():
		velocity=0
		queue_free()

func invert_direction():
	velocity=-velocity
	set_scale(Vector2(-1, 1))
