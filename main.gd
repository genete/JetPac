
extends Node2D
var p1=true
var p2=false
var kb=true
var kj=false
var counter=0
const CONTROLS_TIMEOUT=10

func _ready():
	var global=get_node("/root/global")
	var p1=global.player1_points
	var hi=global.hi_points
	get_node("Header/1UP_POINTS").set_text(str(p1).pad_zeros(6))
	get_node("Header/HI_POINTS").set_text(str(hi).pad_zeros(6))
	OS.set_window_size(Vector2(256, 192)*4)
	OS.set_window_resizable(false)
	set_process(true)
	get_node("1PG").activate(true)
	get_node("3KEY").activate(true)
	pass

func _process(delta):
	var one_p=Input.is_action_pressed("one_player")
	var two_p=Input.is_action_pressed("two_player")
	var keyb=Input.is_action_pressed("keyboard")
	var joy=Input.is_action_pressed("joystick")
	var new_game=Input.is_action_pressed("new_game")
	var controls=Input.is_action_pressed("controls")
	counter+=delta
	if counter > CONTROLS_TIMEOUT:
		controls=true
		counter=0
	
	if one_p: 
		get_node("1PG").activate(true)
		get_node("2PG").activate(false)
		p1=true
		p2=false
	if two_p:
		get_node("1PG").activate(false)
		get_node("2PG").activate(true)
		p1=false
		p2=true
	if keyb:
		get_node("3KEY").activate(true)
		get_node("4KEM").activate(false)
		kb=true
		kj=false
	if joy:
		get_node("3KEY").activate(false)
		get_node("4KEM").activate(true)
		kb=false
		kj=true
	
	if new_game:
		var global=get_node("/root/global")
		global.goto_scene("res://level.tscn")
	
	if controls:
		var global=get_node("/root/global")
		global.goto_scene("res://how_to_play.tscn")