
extends Sprite


func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
	var origin
	var c=is_centered()
	var w=get_texture().get_size().x
	var h=get_texture().get_size().y
	if c:
		origin=Vector2(0,h/2.0)
	else:
		origin=Vector2(w/2, h/2)
	var dest = origin +Vector2(0,8)
	draw_line(origin, dest, Color(1,0,0), 4)
	draw_line(dest, dest+Vector2(2, -4), Color(1,0,0), 4)
	draw_line(dest, dest+Vector2(-2, -4), Color(1,0,0), 4)
	pass
