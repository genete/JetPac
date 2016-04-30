
extends Node2D

var destroy=false

func _ready():
	set_process(true)
	get_node("Big").hide()
	get_node("Medium").hide()
	get_node("Small").hide()
	
func _process(delta):
	var anim=get_node("anim")
	if (anim.is_playing()):
		destroy=true
	if(destroy and not anim.is_playing()):
		queue_free() 


