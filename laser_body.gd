
extends KinematicBody2D

var velocity = 600
var velocity_sign 
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }
var total_motion=Vector2(0,0)

func _ready():
	set_fixed_process(true)
	velocity_sign=velocity/abs(velocity)
	var sprite=get_node("laser_sprite")
	sprite.set_modulate(colors[randi()%7+1])
	add_collision_exception_with(get_node("../Ship0/body00"))
	add_collision_exception_with(get_node("../Ship0/body01"))
	add_collision_exception_with(get_node("../Ship0/body02"))
	

func _fixed_process(delta):
	var motion=Vector2(velocity, 0)*delta
	move(motion)
	total_motion+=motion
	if is_colliding():
		velocity=0
		queue_free()
		var collider=get_collider()
		if collider.has_method("destroy"):
			collider.destroy()
	if total_motion.length() > 200:
		queue_free()
	var pos=get_pos()
	var right_limit=get_viewport_rect().end.x
	var left_limit=get_viewport_rect().pos.x
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))

func invert_direction():
	velocity=-velocity
	get_node("laser_sprite").set_scale(Vector2(-1, 1))
