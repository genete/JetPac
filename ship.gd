
extends Node2D

var player_class=preload("res://player.gd")
var ship_body_class=preload("res://body.gd")
var picked_01=false
var picked_02=false


func _ready():
	get_node("body01/area01").set_enable_monitoring(true)
	get_node("body02/area02").set_enable_monitoring(false)
	get_node("body00").add_collision_exception_with(get_node("body01"))
	get_node("body00").add_collision_exception_with(get_node("body02"))
	get_node("body01").add_collision_exception_with(get_node("body02"))
	



func _on_body01_body_enter( body ):
	if body extends player_class:
		var body01=get_node("body01")
		var player=body
		var dis=body01.get_pos()-player.get_pos()
		remove_child(body01)
		player.add_child(body01)
		body01.set_pos(dis)
		body01.stop_gravity()


func _on_body02_body_enter( body ):
	if body extends player_class:
		var body02=get_node("body02")
		var player=body
		var dis=body02.get_pos()-player.get_pos()
		remove_child(body02)
		player.add_child(body02)
		body02.set_pos(dis)
		body02.stop_gravity()

func _on_ship_launch_pos_body_enter( body ):
	var b1=body.has_node("body01")
	var b2=body.has_node("body02")
	if b1 or b2:
		if body extends player_class:
			var player=body
			var ship_body
			if b1:
				ship_body=player.get_node("body01")
			else:
				ship_body=player.get_node("body02")
			player.remove_child(ship_body)
			add_child(ship_body)
			ship_body.set_pos(Vector2(get_node("body00").get_pos().x, player.get_pos().y))
			ship_body.start_gravity()
			if b1:
				get_node("body01/area01").set_enable_monitoring(false)
				get_node("body00").remove_collision_exception_with(get_node("body01"))
				get_node("body02/area02").set_enable_monitoring(true)
			else:
				ship_body.get_node("area02").set_enable_monitoring(false)
				get_node("body01").remove_collision_exception_with(get_node("body02"))
				



func _on_launch_area_body_enter( body ):
	if body extends ship_body_class:
		if body.get_name() != "body00":
			print("stop gravity", body.get_name())
			body.stop_gravity()
