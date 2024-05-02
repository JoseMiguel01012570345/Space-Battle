extends Node2D

var offset = 0
var turn = "right"
var speed = 0.125

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	if turn == "right":
		desplace_right()
	else:
		desplace_left()
	
	print(speed)
	pass

func desplace_right():
	
	global_position.x += speed
	offset += speed
	if offset == 100:
		turn = "left"
	
	pass

func desplace_left():
	
	global_position.x -= speed
	offset -= speed
	if offset == 0:
		turn = "right"
	
	pass
