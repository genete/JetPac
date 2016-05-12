
extends Node2D

const INTERVAL=0.5
var time=0

func _ready():
	activate(false)
	pass

func _process(delta):
	time=time+delta
	if(time>INTERVAL):
		var zero=get_child(0)
		var one=get_child(1)
		var two=get_child(2)
		if zero.is_hidden(): zero.show()
		else: zero.hide()
		if one.is_hidden(): one.show()
		else: one.hide()
		if two.is_hidden(): two.show()
		else: two.hide()
		time=0

func activate(a):
	set_process(a)


