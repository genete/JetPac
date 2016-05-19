
extends Node2D


func _ready():
	for i in range (1, 6):
		var g_node=get_node("Gem"+str(i))
		var p_node=get_node("Gem"+str(i)+"_pos")
		g_node.set_pos(p_node.get_pos())
		g_node.stop_gravity()
		g_node.velocity=Vector2()
	pass


