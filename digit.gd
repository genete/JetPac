
extends Sprite

var value

func _ready():
	value=0
	parse(value)

func parse(var new_value):
	value=new_value
	if value>9:
		value=9
	if value<0:
		value=0
	set_frame(int(value))

func modulate(c):
	set_modulate(c)