
extends Node2D


func _ready():
	for i in range (1, 9):
		var e_node=get_node("enemy"+str(i))
		var p_node=get_node("enemy"+str(i)+"_pos")
		e_node.set_pos(p_node.get_pos())
		e_node.set_fixed_process(false)
		e_node.get_node("Sprite").set_modulate(e_node.colors[i])
	pass


