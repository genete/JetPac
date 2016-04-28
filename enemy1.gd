##### ENEMY 1
extends KinematicBody2D

const HORIZONTAL_VELOCITY=80
const VERTICAL_VELOCITY=15
var velocity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }


func _ready():
	randomize()
	set_fixed_process(true)
	var height=192-16
	var width=256
	var s=randi()%2
	if s==0:
		s=-1
	velocity=Vector2(HORIZONTAL_VELOCITY*s, randf()*VERTICAL_VELOCITY)
	velocity.x=velocity.x/3
	var sprite_width=get_node("Sprite").get_texture().get_width()
	if s == -1:
		set_pos(Vector2(-sprite_width, randf()*height+16))
	else:
		get_node("Sprite").set_scale(Vector2(-1,1))
		set_pos(Vector2(width+sprite_width, randf()*height+16))
	get_node("Sprite/anim").play("fly")
#	get_node("Sprite").set_modulate(colors[randi()%7+1])
	get_node("Sprite").set_modulate(colors[1])

func _fixed_process(delta):
	var motion=velocity*delta
	move(motion)
	if is_colliding():
		destroy()
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))
		
func destroy():
	velocity=0
	queue_free()
