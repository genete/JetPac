##### ENEMY 4
extends KinematicBody2D

const SINE_AMPLITUDE=10
const VELOCITY=50
var velocity=Vector2(0,0)
var colors={ 1:Color(1,0,0,1), 2:Color(0,1,0,1), 3:Color(0,0,1,1), 4:Color(1, 1, 1, 1), 5:Color(1, 1, 0, 1), 6: Color(1, 0, 1, 1), 7: Color(0,1, 1, 1), 8:Color(1,1,1,1) }
var direction=0
var time=0
var explosion= preload("res://explosion.tscn")
var launched=false
var found=false
var starting_pos=Vector2()

signal enemy_died(p)

func _ready():
	randomize()
	set_fixed_process(true)
	var height=192-16-8-32
	var width=256
	var s=randi()%2
	if s==0:
		s=-1
	var sprite_width=get_node("Sprite").get_texture().get_width()
	if s == -1:
		starting_pos=Vector2(0, randf()*height+16)
	else:
		get_node("Sprite").set_scale(Vector2(-1,1))
		get_node("Sprite").set_pos(Vector2(sprite_width,0))
		starting_pos=Vector2(width-sprite_width, randf()*height+16)
	set_pos(starting_pos)
	get_node("Sprite").set_modulate(colors[randi()%colors.size()+1])
	add_user_signal("enemy_died")
	connect("enemy_died", get_node("/root/World"), "_callback_enemy_died")

func _fixed_process(delta):
	var motion
	var target
	motion=velocity*delta
	move(motion)
	if(is_colliding()):
		var collider=get_collider()
		print("*********collider name ", collider.get_name())
		if collider.has_method("destroy"):
			collider.destroy(true)
		destroy(true)	
	time=time+delta
	if not launched:
		move_to(starting_pos+Vector2(0, SINE_AMPLITUDE*sin(2*time)))
		var space_state = get_world_2d().get_direct_space_state()
		var player_global_pos=get_node("/root/World/Player").get_global_pos()
		var exclusion_array=[self, 
			get_node("/root/World/Ship/body00"), 
			get_node("/root/World/Ship/body01"), 
			get_node("/root/World/Ship/body02"),
			get_node("/root/world/Player/body01"),
			get_node("/root/world/Player/body02")
			]
		var result = space_state.intersect_ray( get_global_pos(), player_global_pos, exclusion_array )
		if (not result.empty()):
			if result.collider and result.collider.get_name()=="Player":
				found=true
				target=result.position
	if found and not launched:
		velocity=target-get_global_pos()
		velocity=velocity.normalized()*VELOCITY
		launched=true

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

func get_points():
	return 20
