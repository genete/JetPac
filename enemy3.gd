##### ENEMY 3
extends KinematicBody2D

const HORIZONTAL_VELOCITY=80
const VERTICAL_VELOCITY=80
const DIRECTION_CHANGE_TIME=3
var velocity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }
var direction=0
const DEG45=PI/4
var counter=0

func _ready():
	randomize()
	set_fixed_process(true)
	var height=192-16
	var width=256
	velocity=Vector2(HORIZONTAL_VELOCITY, VERTICAL_VELOCITY).rotated(direction)
	velocity=velocity/3
	var sprite_width=get_node("Sprite").get_texture().get_width()
	set_pos(Vector2(-sprite_width, randf()*height+16))
	get_node("Sprite/anim").play("fly")
	get_node("Sprite").set_modulate(colors[randi()%colors.size()+1])


func _fixed_process(delta):
	var motion=velocity*delta
	counter=counter+delta
	var current_vel=velocity
	var colliding=false
	move(motion)
	if(is_colliding()):
		colliding=true
		var obj=get_collider()
		var n=get_collision_normal()
		motion=n.slide(motion)
		velocity=n.slide(velocity)
		move(motion)
		current_vel=-current_vel
		var angle=current_vel.angle_to(n)
		current_vel=current_vel.rotated(2*angle)
		velocity=current_vel
		if(obj.get_name()=="laser_body"):
			destroy()
	if !colliding and counter > DIRECTION_CHANGE_TIME:
		change_direction()
		velocity=velocity.rotated(direction)
		counter=0
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))
	change_direction()
		
func destroy():
	velocity=Vector2(0,0)
	queue_free()

func change_direction():
	var c=randi()%3
	if c==0:
		direction=direction-DEG45
	if c==1:
		direction=direction
	if c==2:
		direction=direction+DEG45
