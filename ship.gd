
extends Node2D

var player_class=preload("res://player.gd")
var ship_body_class=preload("res://body.gd")
var fuel_class=preload("res://fuel.gd")
var assembled=false
var fuel_level=0
var sprites={
1:"body00/sprite000",
2:"body00/sprite001",
3:"body01/sprite010",
4:"body01/sprite011",
5:"body02/sprite020",
6:"body02/sprite021"
}
var remaining_fuel_units
const FUEL_COLOR=Color(125.0/255, 0, 191.0/255)
var fuel_color=FUEL_COLOR
var fuel_scene=preload("res://fuel.tscn")
var counter=0
const COUNTER_MAX=0.5
var player_is_in_ship=false
var launch_played=false
var launch_played_backward=false


func _ready():
	set_process(true)
	get_node("body01/area01").set_enable_monitoring(true)
	get_node("body02/area02").set_enable_monitoring(false)
	get_node("body00").add_collision_exception_with(get_node("body01"))
	get_node("body00").add_collision_exception_with(get_node("body02"))
	get_node("body01").add_collision_exception_with(get_node("body02"))
	add_user_signal("ship_assembled")

func _process(delta):
	# if assembled draw the filled fuel
	if assembled:
		for f in range (0, 6):
			var node_path=sprites[f+1]
			var sprite=get_node(node_path)
			if f+1<= fuel_level:
				sprite.set_modulate(fuel_color)
			else:
				sprite.set_modulate(Color(1,1,1,1))
	# if assembled and not fuel filled and no fuel unit present, then drop a fuel
	remaining_fuel_units=6-fuel_level
	var player_has_fuel=get_node("../Player").has_node("Fuel")
	var ship_scene_has_fuel=has_node("Fuel")
	if assembled and remaining_fuel_units>0 and not player_has_fuel and not ship_scene_has_fuel and not player_is_in_ship:
		var fuel_instance=fuel_scene.instance()
		add_child(fuel_instance)
		fuel_instance.add_collision_exception_with(get_node("../Player"))
		fuel_instance.add_collision_exception_with(get_node("body00"))
		fuel_instance.add_collision_exception_with(get_node("body01"))
		fuel_instance.add_collision_exception_with(get_node("body02"))
		var area=fuel_instance.get_node("fuel_area")
		area.connect("body_enter", self, "_on_fuel_body_enter")
	# if assembled and full filled, blink the ship
	if assembled and not remaining_fuel_units:
		counter+=delta
		if counter>COUNTER_MAX and fuel_color==FUEL_COLOR:
			fuel_color=Color(1,1,1,1)
			counter=0
		elif counter>COUNTER_MAX and fuel_color==Color(1,1,1,1):
			fuel_color=FUEL_COLOR
			counter=0
	# if player is in the ship do the animations 
	if player_is_in_ship:
		var flames=get_node("body00/flames")
		flames.show()
		var flames_anim=flames.get_node("anim")
		if not flames_anim.is_playing():
			flames_anim.play("flames")
		get_node("body00").stop_gravity()
		get_node("body01").stop_gravity()
		get_node("body02").stop_gravity()
		var anim=get_node("anim")
		if not anim.is_playing():
			if not launch_played:
				anim.play("launch")
				launch_played=true
			elif not launch_played_backward:
				anim.play_backwards("launch")
				launch_played_backward=true
				fuel_level=0
			elif launch_played and launch_played_backward:
				flames_anim.stop()
				flames.hide()
				get_node("/root/Node/Player").show()
				player_is_in_ship=false
				fuel_color=FUEL_COLOR
				launch_played=false
				launch_played_backward=false
			
#PLAYER GETS FUEL
func _on_fuel_body_enter( body ):
	if body extends player_class:
		var fuel=get_node("Fuel")
		var player=body
		var dis=fuel.get_pos()-player.get_pos()
		remove_child(fuel)
		player.add_child(fuel)
		fuel.set_pos(dis)
		fuel.stop_gravity()

# PLAYER GETS FIRST SECTION
func _on_body01_body_enter( body ):
	if body extends player_class:
		var body01=get_node("body01")
		var player=body
		var dis=body01.get_pos()-player.get_pos()
		remove_child(body01)
		player.add_child(body01)
		body01.set_pos(dis)
		body01.stop_gravity()

# PLAYER GETS SECOND SECTION
func _on_body02_body_enter( body ):
	if body extends player_class:
		var body02=get_node("body02")
		var player=body
		var dis=body02.get_pos()-player.get_pos()
		remove_child(body02)
		player.add_child(body02)
		body02.set_pos(dis)
		body02.stop_gravity()

# PLAYER CROSSES LAUNCH POSITION
func _on_ship_launch_pos_body_enter( body ):
	if body extends ship_body_class:
		var player=get_node("../Player")
		if player.has_node("body01") or player.has_node("body02"):
			player.remove_child(body)
			add_child(body)
			var dis=body.get_pos()
			body.set_pos(Vector2(get_node("body00").get_pos().x, player.get_pos().y+dis.y))
			body.start_gravity()
			if body.get_name() == "body01":
				body.get_node("area01").set_enable_monitoring(false)
				get_node("body00").remove_collision_exception_with(get_node("body01"))
				get_node("body02/area02").set_enable_monitoring(true)
			elif body.get_name()== "body02":
				get_node("body02/area02").set_enable_monitoring(false)
				get_node("body01").remove_collision_exception_with(get_node("body02"))
##### OLD VERSION
#	var b1=body.has_node("body01")
#	var b2=body.has_node("body02")
#	if b1 or b2:
#		if body extends player_class:
#			var player=body
#			var ship_body
#			if b1:
#				ship_body=player.get_node("body01")
#			else:
#				ship_body=player.get_node("body02")
#			player.remove_child(ship_body)
#			add_child(ship_body)
#			ship_body.set_pos(Vector2(get_node("body00").get_pos().x, player.get_pos().y))
#			ship_body.start_gravity()
#			if b1:
#				get_node("body01/area01").set_enable_monitoring(false)
#				get_node("body00").remove_collision_exception_with(get_node("body01"))
#				get_node("body02/area02").set_enable_monitoring(true)
#			else:
#				ship_body.get_node("area02").set_enable_monitoring(false)
#				get_node("body01").remove_collision_exception_with(get_node("body02"))
	if body.has_node("Fuel"):
		if body extends player_class:
			var player=body
			var fuel=player.get_node("Fuel")
			var dis=fuel.get_pos()
			player.remove_child(fuel)
			add_child(fuel)
			fuel.set_pos(Vector2(get_node("body00").get_pos().x, player.get_pos().y+dis.y))
			fuel.start_gravity()
			fuel.get_node("fuel_area").set_enable_monitoring(false)



func _on_launch_area_body_enter( body ):
	if (body extends ship_body_class) and not (body.get_parent() extends player_class):
		if body.get_name() != "body00":
			body.stop_gravity()
			if body.get_name() == "body02":
				assembled=true
	if assembled and not remaining_fuel_units:
		if body extends player_class:
			body.hide()
			player_is_in_ship=true



func _on_fuel_area_body_enter( body ):
	if body extends fuel_class:
		fuel_level+=1
		body.queue_free()
		