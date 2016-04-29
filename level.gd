
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var current_wave=1
const TOTAL_ENEMIES_TYPES=2
const WAVE_CHANGE_SHIP=2
var enabled_enemies=true
var enemies_scenes={
1: preload("enemy1.tscn"),
2: preload("enemy2.tscn")
}
const MAX_ENEMIES_COUNT=4

func _ready():
	OS.set_window_size(Vector2(256, 192)*4)
	OS.set_window_resizable(false)
	set_process(true)
	spawn_enemies(MAX_ENEMIES_COUNT)

func spawn_enemies(total):
	var enemy_scene=enemies_scenes[current_wave]
	var enemies=get_node("Enemies")
	for i in range(0, total):
		var enemy_instance=enemy_scene.instance()
		enemies.add_child(enemy_instance)
		enemy_instance.add_to_group("enemies")
		enemy_instance.add_collision_exception_with(get_node("roof"))
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
#		print ("spawning ", MAX_ENEMIES_COUNT-count, " enemies")
#		print ("count = ", count)
		spawn_enemies(MAX_ENEMIES_COUNT-count)

func destroy_enemies():
	get_tree().call_group(2, "enemies", "destroy")

func enable_enemies():
	enabled_enemies=true

func disable_enemies():
	enabled_enemies=false

func next_wave():
	var ret=false
	current_wave+=1
	if current_wave > WAVE_CHANGE_SHIP:
		ret = true
	if current_wave > TOTAL_ENEMIES_TYPES:
		current_wave=1
		# increase velocity or number of enemies here
	return ret

func get_total_enemies_types():
	return WAVE_CHANGE_SHIP