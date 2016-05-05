##### ENEMY 7
extends KinematicBody2D

const HORIZONTAL_VELOCITY=40
const VERTICAL_VELOCITY=15
var velocity
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1) }
var explosion= preload("res://explosion.tscn")


func _ready():
	randomize()
	set_fixed_process(true)
	var height=192-16-8-32
	var width=256
	var s=randi()%2
	if s==0:
		s=-1
	velocity=Vector2(HORIZONTAL_VELOCITY*s, (0.2+randf())*VERTICAL_VELOCITY)
	var sprite_width=get_node("Sprite").get_texture().get_width()
	if s == -1:
		set_pos(Vector2(-sprite_width, randf()*height+16))
	else:
		get_node("Sprite").set_scale(Vector2(-1,1))
		get_node("Sprite").set_pos(Vector2(12,0))
		set_pos(Vector2(width+sprite_width, randf()*height+16))
	get_node("Sprite/anim").play("fly")
	get_node("Sprite").set_modulate(colors[randi()%7+1])

func _fixed_process(delta):
	var motion=velocity*delta
	move(motion)
	if is_colliding():
		var collider=get_collider()
		if collider.has_method("destroy"):
			collider.destroy(true)
		destroy(true)
	var pos=get_pos()
	var right_limit=256
	var left_limit=0
	if(pos.x < left_limit):
		set_pos(pos+Vector2(right_limit,0))
	elif(pos.x > right_limit):
		set_pos(pos-Vector2(right_limit, 0))
	if pos.x < left_limit-64 or pos.x >right_limit + 64 or pos.y < 0 or pos.y > 192:
			destroy(false)

		
func destroy(var animate):
	velocity=Vector2(0,0)
	if animate:
		var exp_instance=explosion.instance()
		get_node("/root/World").add_child(exp_instance)
		exp_instance.set_pos(get_pos()+Vector2(8, 8))
		exp_instance.get_node("anim").play("explode")
	queue_free()
