
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


func _fixed_process(delta):
	var motion=Vector2(velocity, 0)*delta
	move(motion)
	total_motion+=motion
	if is_colliding():
		velocity=0
		queue_free()
		var collider=get_collider()
		if collider.has_method("get_points"):
			var points=collider.get_points()
			if collider.has_user_signal("enemy_died"):
				collider.emit_signal("enemy_died", points)
			else:
				print("no signal")
		if collider.has_method("destroy"):
			collider.destroy(true)
	if total_motion.length() > 200:
		queue_free()
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))

func invert_direction():
	velocity=-velocity
	get_node("laser_sprite").set_scale(Vector2(-1, 1))
