##### ENEMY 2
extends KinematicBody2D

const HORIZONTAL_VELOCITY=50
const VERTICAL_VELOCITY=50
var velocity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }
var explosion= preload("res://explosion.tscn")


func _ready():
	randomize()
	set_fixed_process(true)
	var height=192-16-8
	var width=256
	var s=randi()%2
	if s==0:
		s=-1
	velocity=Vector2(HORIZONTAL_VELOCITY*s, VERTICAL_VELOCITY*s)
	var sprite_width=get_node("Sprite").get_texture().get_width()
	if s == -1:
		set_pos(Vector2(-sprite_width, randf()*height+16))
	else:
		set_pos(Vector2(width+sprite_width, randf()*height+16))
	get_node("Sprite/anim").play("fly")
	get_node("Sprite").set_modulate(colors[randi()%colors.size()+1])


func _fixed_process(delta):
	var motion=velocity*delta
	var current_vel=velocity
	move(motion)
	if(is_colliding()):
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
			destroy(true)
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))
		
func destroy(var animate):
	velocity=Vector2(0,0)
	if animate:
		var exp_instance=explosion.instance()
		get_node("/root/World").add_child(exp_instance)
		exp_instance.set_pos(get_pos()+Vector2(8, 8))
		exp_instance.get_node("anim").play("explode")
	queue_free()
