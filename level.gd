
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
var player_class=preload("res://player.gd")
var gems_scenes={
1: preload("gems/gem1.tscn"),
2: preload("gems/gem2.tscn"),
3: preload("gems/gem3.tscn")
}
const MAX_ENEMIES_COUNT=4
const HOLD_SPAWN_ENEMIES=0.5
var time_counter=0
var points=0
var hipoints=0
var lives=3

var gems_time_counter=0
const GEMS_SPAWN_TIME=1

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

func spawn_gem():
	var gems=gems_scenes.size()
	var selected=randi()%gems+1
	print("selected ", selected)
	var gem_instance=gems_scenes[selected].instance()
	var area=gem_instance.get_node("gem_area")
	get_node("Gems").add_child(gem_instance)
	area.connect("body_enter", self, "_on_gem_body_enter")
	pass

func _process(delta):
	var enemies=get_node("Enemies")
	var count=enemies.get_child_count()
	if (MAX_ENEMIES_COUNT-count)>0 and enabled_enemies:
		time_counter+=delta
		if time_counter>HOLD_SPAWN_ENEMIES:
			spawn_enemies(1)
			time_counter=0
	var gems_node=get_node("Gems")
	var gem_present=gems_node.get_child_count()>0
	if not gem_present:
		gems_time_counter+=delta
		if gems_time_counter> GEMS_SPAWN_TIME:
			spawn_gem()
			gems_time_counter=0
		
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

func _on_gem_body_enter(body):
	if body extends player_class:
		var gem_node=get_node("Gems").get_child(0)
		var p=gem_node.get_points()
		gem_node.queue_free()
		increase_points(p)
		pass
	pass

func _callback_enemy_died(var p):
	increase_points(p)

func increase_points(p):
	points=points+p
	if points>hipoints:
		hipoints=points
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
