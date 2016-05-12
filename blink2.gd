
extends Node2D

var active

func _ready():
	activate(false)
	pass


func activate(a):
	active=a
	if not active:
		get_child(0).show()
		get_child(1).hide()
		get_child(2).hide()


func _on_TimerOn_timeout():
	if not active: return
	get_child(0).show()
	get_child(1).hide()
	get_child(2).hide()

func _on_TimerOff_timeout():
	if not active: return
	get_child(0).hide()
	get_child(1).show()
	get_child(2).show()