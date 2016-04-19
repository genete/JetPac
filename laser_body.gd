
extends KinematicBody2D

var velocity = 600
var velocity_sign 
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }

func _ready():
	set_fixed_process(true)
	velocity_sign=velocity/abs(velocity)
	var sprite=get_node("laser_sprite")
	sprite.set_modulate(colors[randi()%7+1])

func _fixed_process(delta):
	var motion=Vector2(velocity, 0)*delta
	move(motion)
	if is_colliding():
		velocity=0
		queue_free()

func invert_direction():
	velocity=-velocity
	set_scale(Vector2(-1, 1))
