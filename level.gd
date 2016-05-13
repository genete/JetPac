
extends Node2D


var current_wave=1
var current_enemy=1
const TOTAL_ENEMIES_TYPES=8
const MAX_WAVES_PER_SHIP=3
var enabled_enemies=true
var enemies_scenes={
1: preload("enemies/enemy1.tscn"),
2: preload("enemies/enemy2.tscn"),
3: preload("enemies/enemy3.tscn"),
4: preload("enemies/enemy4.tscn"),
5: preload("enemies/enemy5.tscn"),
6: preload("enemies/enemy6.tscn"),
7: preload("enemies/enemy7.tscn"),
8: preload("enemies/enemy8.tscn")
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
	get_node("Header/LIVES").set_text(str(lives))
	var global=get_node("/root/global")
	hipoints=global.hi_points
	update_points()

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
		if time_counter>HOLD_SPAWN_ENEMIES:
			spawn_enemies(1)
			time_counter=0
	var pause = Input.is_action_pressed("pause")
	if pause:
		get_tree().set_pause(true)
		get_node("Pause label").show()

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
	if current_wave >MAX_WAVES_PER_SHIP:
		current_wave=1
		ret = true
	if current_enemy > TOTAL_ENEMIES_TYPES:
		current_enemy=1
		# increase velocity or number of enemies here
	return ret

func get_max_waves_per_ship():
	return MAX_WAVES_PER_SHIP


func _callback_enemy_died(var p):
	points=points+p
	if points>hipoints:
		hipoints=points
	print("Points ", points)
	update_points()

func update_points():
	get_node("Header/1UP_POINTS").set_text(str(points).pad_zeros(6))
	get_node("Header/HI_POINTS").set_text(str(hipoints).pad_zeros(6))

func _callback_player_died():
	lives-=1
	if lives<=0:
		lives=0
		get_node("Header/LIVES").set_text(str(lives))
		print ("GAME OVER")
		var global=get_node("/root/global")
		global.player1_points=points
		global.hi_points=hipoints
		global.goto_scene("res://main.tscn")
	get_node("Header/LIVES").set_text(str(lives))
