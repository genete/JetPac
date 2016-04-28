
extends Node2D

var player_class=preload("res://player.gd")
var ship_body_class=preload("res://body.gd")
var fuel_class=preload("res://fuel.gd")
var fuel_scene=preload("res://fuel.tscn")

var sprites={
1:"body00/sprite000",
2:"body00/sprite001",
3:"body01/sprite010",
4:"body01/sprite011",
5:"body02/sprite020",
6:"body02/sprite021"
}
const MAX_FUEL=1
const FUEL_COLOR=Color(192.0/255, 0, 192.0/255)
const COLOR_WHITE=Color(1,1,1)
const COUNTER_MAX=0.5
const LAST_SHIP=4
var max_waves

var assembled=false
var fuel_level=0
var remaining_fuel_units
var fuel_color=FUEL_COLOR
var counter=0
var player_is_in_ship=false
var launch_played=false
var launch_played_backward=false
var waves_counter=0
var current_ship=1


func _ready():
	set_process(true)
	prepare_ship(current_ship)
	max_waves=get_node("/root/World").get_total_enemies_types()


func prepare_ship(current_ship):
	var body00=get_node("body00")
	var body01=get_node("body01")
	var body02=get_node("body02")
	body00.get_node("ship_launch_pos").set_enable_monitoring(false)
	body01.get_node("area01").set_enable_monitoring(true)
	body02.get_node("area02").set_enable_monitoring(false)
	body00.add_collision_exception_with(body01)
	body00.add_collision_exception_with(body02)
	body01.add_collision_exception_with(body02)
	body00.set_pos(get_node("body00_pos").get_pos())
	body01.set_pos(get_node("body01_pos").get_pos())
	body02.set_pos(get_node("body02_pos").get_pos())
	var sprite000=body00.get_node("sprite000")
	var sprite001=body00.get_node("sprite001")
	var sprite010=body01.get_node("sprite010")
	var sprite011=body01.get_node("sprite011")
	var sprite020=body02.get_node("sprite020")
	var sprite021=body02.get_node("sprite021")
	sprite000.set_frame(20+current_ship-1)
	sprite001.set_frame(16+current_ship-1)
	sprite010.set_frame(12+current_ship-1)
	sprite011.set_frame(8+current_ship-1)
	sprite020.set_frame(4+current_ship-1)
	sprite021.set_frame(0+current_ship-1)
	body00.get_node("ship_launch_pos").set_enable_monitoring(true)

func next_ship():
	set_pos(Vector2(0,0))
	current_ship+=1
	if current_ship>4:
		current_ship=1
	prepare_ship(current_ship)
	get_node("../Player").prepare_player()

func prepare_next_wave():
	print("remove enemies")
	get_node("/root/World").disable_enemies()

func next_wave():
	print("next_wave")
	var world=get_node("/root/World")
	world.enable_enemies()
	return world.next_wave()

func paint_fuel_on_ship():
	for f in range (0, MAX_FUEL):
		var node_path=sprites[f+1]
		var sprite=get_node(node_path)
		if f+1<= fuel_level:
			sprite.set_modulate(fuel_color)
		else:
			sprite.set_modulate(COLOR_WHITE)

func _process(delta):
	# if assembled draw the filled fuel
	if assembled:
		paint_fuel_on_ship()
	# if assembled and not fuel filled and no fuel unit present, then drop a fuel
	remaining_fuel_units=MAX_FUEL-fuel_level
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
#		print("assembled. remaining fuel = ",remaining_fuel_units)
		counter+=delta
		if counter>COUNTER_MAX and fuel_color==FUEL_COLOR:
			fuel_color=COLOR_WHITE
			counter=0
		elif counter>COUNTER_MAX and fuel_color==COLOR_WHITE:
			fuel_color=FUEL_COLOR
			counter=0
	# if player is in the ship do the animations 
	var change_ship=false
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
				waves_counter+=1
				prepare_next_wave()
			elif not launch_played_backward:
				if not waves_counter>=max_waves:
					anim.play_backwards("launch")
					launch_played_backward=true
					fuel_level=0
		if not anim.is_playing():
			if launch_played and (launch_played_backward or waves_counter>=max_waves):
				fuel_level=0
				flames_anim.stop()
				flames.hide()
				get_node("/root/World/Player").show()
				player_is_in_ship=false
				fuel_color=FUEL_COLOR
				launch_played=false
				launch_played_backward=false
		if not player_is_in_ship:
			change_ship=next_wave()
		if change_ship and not anim.is_playing():
			fuel_level=0
			assembled=false
			paint_fuel_on_ship()
			next_ship()

			
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
		print("body extends ship body class: ", body.get_name())
		var player=get_node("../Player")
		if player.has_node("body01") or player.has_node("body02"):
			player.remove_child(body)
			add_child(body)
			if body.get_name() == "body01":
				body.get_node("area01").set_enable_monitoring(false)
				get_node("body00").remove_collision_exception_with(get_node("body01"))
				get_node("body02/area02").set_enable_monitoring(true)
			elif body.get_name()== "body02":
				get_node("body02/area02").set_enable_monitoring(false)
				get_node("body01").remove_collision_exception_with(get_node("body02"))
			var dis=body.get_pos()
			body.set_pos(Vector2(get_node("body00").get_pos().x, player.get_pos().y+dis.y))
			body.start_gravity()

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
		