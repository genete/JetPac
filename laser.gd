
extends Node2D

var starting_pos=Vector2()
var pos=starting_pos
var velocity=600 
var line_col=Color(0, 1, 0, 1)
var line_width=1
var laser_length=150
var laser_solid=0.6
var dot_length=10
var space_length=8
var velocity_sign
var collision_shape_height=1

func _ready():
	set_fixed_process(true)
	pos=starting_pos
	velocity_sign=velocity/abs(velocity)
	#print(velocity_sign)

func _fixed_process(delta):
	var body= get_node("body")
	var motion=Vector2(velocity, 0)*delta
	body.move(motion)
	if body.is_colliding():
		velocity=0
		queue_free()
	var shape= get_node("body/shape")
	pos=pos+Vector2(velocity*delta, 0)
	var current_laser=pos-starting_pos
	if current_laser.length() < laser_length*laser_solid:
		shape.get_shape().set_extents(current_laser/2+Vector2(0,collision_shape_height))
		shape.set_pos(starting_pos-current_laser/2)
	else:
		shape.get_shape().set_extents(Vector2(laser_length*laser_solid, 2*collision_shape_height)/2)
		shape.set_pos(starting_pos-velocity_sign*Vector2(laser_length*laser_solid, 0)/2)
	if pos.x + laser_length < 0 || pos.x - laser_length > get_viewport_rect().end.x:
		#print("queue free laser")
		queue_free()
	update()

	
func _draw():
	#draw_circle( starting_pos, 3, Color(1, 0, 0, 0.5))
	var current_laser=pos-starting_pos
	if current_laser.length() < laser_length*laser_solid:
		draw_line(starting_pos, pos,line_col, line_width)
		return
	
	else:
		var tail=pos - velocity_sign*Vector2(laser_length*laser_solid,0)
		draw_line(pos, tail, line_col, line_width)
		if current_laser.length()>laser_length:
			current_laser=Vector2(laser_length, 0)
		var start=tail
		var end=start
		var amount=(pos-starting_pos).length()/laser_length
		for i in range(0, 10):
			start=start-velocity_sign*Vector2(space_length+i*amount, 0)
			end=start-velocity_sign*Vector2(dot_length-i*amount,0)
			if current_laser.length() <= (pos-end).length():
				break
			if (end-start).dot(Vector2(velocity,0)) < 0:
				draw_line(start, end, line_col, line_width)
			start=end


func set_starting_pos(p):
	starting_pos=p
func invert_direction():
	velocity=-velocity