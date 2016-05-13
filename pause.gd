
extends Label

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		hide()
		get_tree().set_pause(false)
	pass


