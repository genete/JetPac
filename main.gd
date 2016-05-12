
extends Node2D


func _ready():
	var global=get_node("/root/global")
	var p1=global.player1_points
	var hi=global.hi_points
	get_node("Header/1UP_POINTS").set_text(str(p1).pad_zeros(6))
	get_node("Header/HI_POINTS").set_text(str(hi).pad_zeros(6))
	OS.set_window_size(Vector2(256, 192)*4)
	OS.set_window_resizable(false)
	set_process(true)
	pass

func _process(delta):
	var one_p=Input.is_action_pressed("one_player")
	var two_p=Input.is_action_pressed("two_player")
	var keyb=Input.is_action_pressed("keyboard")
	var joy=Input.is_action_pressed("joystick")
	var new_game=Input.is_action_pressed("new_game")
	
	if one_p:
		
		pass
	
	if new_game:
		var global=get_node("/root/global")
		global.goto_scene("res://level.tscn")
