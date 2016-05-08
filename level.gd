
extends Node2D


var current_wave=1
var current_enemy=1
const TOTAL_ENEMIES_TYPES=8
const MAX_WAVES_PER_SHIP=3
var enabled_enemies=true
var enemies_scenes={
1: preload("enemy4.tscn"),
2: preload("enemy2.tscn"),
3: preload("enemy3.tscn"),
4: preload("enemy4.tscn"),
5: preload("enemy5.tscn"),
6: preload("enemy6.tscn"),
7: preload("enemy7.tscn"),
8: preload("enemy8.tscn")
}
const MAX_ENEMIES_COUNT=4
const HOLD_SPAWN_ENEMIES=0.5
var time_counter=0
var points=0
var hipoints=0
var lives=3

func _ready():
	OS.set_window_size(Vector2(256, 192)*4)
	OS.set_window_resizable(false)
	set_process(true)
	get_node("lives").set_number(lives)

func spawn_enemies(total):
	var enemy_scene=enemies_scenes[current_enemy]
	var enemies=get_node("Enemies")
	for i in range(0, total):
		var enemy_instance=enemy_scene.instance()
		enemies.add_child(enemy_instance)
		enemy_instance.add_to_group("enemies")
#		enemy_instance.add_collision_exception_with(get_node("roof"))
		enemy_instance.add_collision_exception_with(get_node("Ship/body00"))
		if(get_node("Player").has_node("body01")):
			enemy_instance.add_collision_exception_with(get_node("Player/body01"))
		else:
			enemy_instance.add_collision_exception_with(get_node("Ship/body01"))
		if(get_node("Player").has_node("body02")):
			enemy_instance.add_collision_exception_with(get_node("Player/body02"))
		else:
			enemy_instance.add_collision_exception_with(get_node("Ship/body02"))
		if get_node("Ship").has_node("Fuel"):
			enemy_instance.add_collision_exception_with(get_node("Ship/Fuel"))
		var children=enemies.get_child_count()
		for j in range(0, children):
			enemy_instance.add_collision_exception_with(enemies.get_child(j))



func _process(delta):
	var enemies=get_node("Enemies")
	var count=enemies.get_child_count()
	if (MAX_ENEMIES_COUNT-count)>0 and enabled_enemies:
		time_counter+=delta
#		print ("spawning ", MAX_ENEMIES_COUNT-count, " enemies")
#		print ("count = ", count)
		if time_counter>HOLD_SPAWN_ENEMIES:
			spawn_enemies(1)
			time_counter=0
#	return
#	for j in range(0, enemies.get_child_count()):
#		var enemy=enemies.get_child(j)
#		var pos=enemy.get_pos()
#		var vel=enemy.velocity
#		get_node("enemy_label"+str(j)).set_text("Enemy "+str(j) + " position: "+ str(pos) + " velocity "+ str(vel))

func destroy_enemies():
	get_tree().call_group(2, "enemies", "destroy", false)

func enable_enemies():
	enabled_enemies=true

func disable_enemies():
	enabled_enemies=false

func next_wave():
	var ret=false
	current_wave+=1
	current_enemy+=1
#	print("next_wave(): current_wave=", current_wave, "MAX_WAVES_PER_SHIP=", MAX_WAVES_PER_SHIP)
	if current_wave >MAX_WAVES_PER_SHIP:
		current_wave=1
		ret = true
#		print("next_wave(): will return true")
	if current_enemy > TOTAL_ENEMIES_TYPES:
#		print("next_wave():current_enemy>TOTAL ENEMY TYPES =", current_enemy, " will change to 1")
		current_enemy=1
		# increase velocity or number of enemies here
	return ret

func get_max_waves_per_ship():
	return MAX_WAVES_PER_SHIP

func set_up_labels(var total):
	var label_class=preload("res://label.tscn")
	var world=get_node("/root/World")
	for i in range (0, total):
		var lab_instance=label_class.instance()
		world.add_child(lab_instance)
		lab_instance.set_pos(Vector2(0,13*i))
		lab_instance.set_name("enemy_label"+str(i))

func _callback_enemy_died(var p):
	points=points+p
	if points>hipoints:
		hipoints=points
	print("Points ", points)
	get_node("Number_left").set_number(points)
	get_node("Number_center").set_number(hipoints)

func _callback_player_died():
	lives-=1
	get_node("lives").set_number(lives)
	if lives==0:
		print ("GAME OVER")