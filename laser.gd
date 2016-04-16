
extends Node2D

var starting_pos=Vector2(500,100)
var pos=starting_pos
var velocity=600 
var line_col=Color(0, 1, 0, 1)
var line_width=1
var laser_length=150
var laser_solid=0.6
var dot_length=10
var space_length=8
var velocity_sign

func _ready():
	set_process(true)
	pos=starting_pos
	velocity_sign=velocity/abs(velocity)
	print(velocity_sign)

func _process(delta):
	pos=pos+Vector2(velocity*delta, 0)
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