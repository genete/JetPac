
extends Node2D

var ndigits=6
var number
var digit_class=preload("res://digit.tscn")

func _ready():
	number=0
	update_digits()


func update_digits():
	clear_children()
	if number > 10000000:
		print("overflow!")
	var num=number
	for i in range(0, ndigits):
		var n=num/10.0
		var d =int((n-int(n))*10)
		num=n
		var digit_instance=digit_class.instance()
		add_child(digit_instance)
		digit_instance.set_pos(Vector2((ndigits-i-1)*8, 0))
		digit_instance.parse(d)
		

func set_number(var new_number):
	if not new_number==number:
		number=int(new_number)
		update_digits()

func get_number():
	return number

func clear_children():
	while(get_child_count()):
		var c=get_child(0)
		remove_child(c)