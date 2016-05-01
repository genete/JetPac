
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)


func _process(delta):
	if(not get_node("../..").player_is_in_ship):
		var player=get_node("/root/World/Player")
		if overlaps_body(player):
			print("overlaps")
			get_node("../..")._on_launch_area_body_enter(player)


