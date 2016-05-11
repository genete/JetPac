##### ENEMY 3
extends KinematicBody2D

const HORIZONTAL_VELOCITY=40
const VERTICAL_VELOCITY=40
const DIRECTION_CHANGE_TIME=3
var velocity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }
var direction=0
const DEG45=PI/4
var counter=0
var explosion= preload("res://explosion.tscn")

signal enemy_died(p)

func _ready():
	randomize()
	set_fixed_process(true)
	var height=192-16-8-32
	var width=256
	velocity=Vector2(HORIZONTAL_VELOCITY, VERTICAL_VELOCITY).rotated(direction)
	set_pos(Vector2(-16, randf()*height+16))
	get_node("Sprite/anim").play("fly")
	get_node("Sprite").set_modulate(colors[randi()%colors.size()+1])
	add_user_signal("enemy_died")
	connect("enemy_died", get_node("/root/World"), "_callback_enemy_died")


func _fixed_process(delta):
	var motion=velocity*delta
	counter=counter+delta
	var current_vel=velocity
	var colliding=false
	move(motion)
	if(is_colliding()):
		colliding=true
		var collider=get_collider()
		var n=get_collision_normal()
		motion=n.slide(motion)
		velocity=n.slide(velocity)
		move(motion)
		current_vel=-current_vel
		var angle=current_vel.angle_to(n)
		current_vel=current_vel.rotated(2*angle)
		velocity=current_vel
		if(collider.get_name()=="laser_body"):
			destroy(true)
		if collider.has_method("destroy"):
			collider.destroy(true)
	if !colliding and counter > DIRECTION_CHANGE_TIME:
		change_direction()
		velocity=velocity.rotated(direction)
		counter=0
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit-16):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))
	if pos.x < left_limit-64 or pos.x >right_limit + 64 or pos.y < 0 or pos.y > 192:
			destroy(false)
	change_direction()
		
func destroy(var animate):
	velocity=Vector2(0,0)
	if animate:
		var exp_instance=explosion.instance()
		get_node("/root/World").add_child(exp_instance)
		exp_instance.set_pos(get_pos()+Vector2(8, 8))
		exp_instance.get_node("anim").play("explode")
	queue_free()

func change_direction():
	var c=randi()%3
	if c==0:
		direction=direction-DEG45
	if c==1:
		direction=direction
	if c==2:
		direction=direction+DEG45

func get_points():
	return 15
