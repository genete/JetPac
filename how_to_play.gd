
extends Node2D
var counter=0
const CONTROLS_TIMEOUT=10

func _ready():
	OS.set_window_size(Vector2(256, 192)*4)
	OS.set_window_resizable(false)
	get_node("Jet/anim").play("flying")
	get_node("Right/anim").play("walk")
	get_node("Left/anim").play("walk")
	get_node("Laser/anim").play("idle")
	get_node("Laser/pos/laser_sprite/anim").get_animation("shot").set_loop(true)
	get_node("Laser/pos/laser_sprite/anim").play("shot")
	set_process_input(true)
	set_process(true)
	pass

func _input(event):
	if event.is_pressed():
		get_node("/root/global").goto_scene("res://main.tscn")
	pass

func _process(delta):
	counter+=delta
	if counter > CONTROLS_TIMEOUT:
		counter=0
		get_node("/root/global").goto_scene("res://main.tscn")
	pass
