extends Node2D

var offset = 0
var turn = "right"
var speed = 0.125
var texture_position = global_position - Vector2(100,0)

func _ready():
	
	$error.hide()
	$error2.hide()
	$error3.hide()
	
	pass # Replace with function body.

func _process(delta):
	
	if turn == "right":
		desplace_right()
	else:
		desplace_left()
	
	pass

func desplace_right():
	
	texture_position.x += speed
	
	$TextureRect.set_global_position(texture_position)
	offset += speed
	if offset == 100:
		turn = "left"
	
	pass

func desplace_left():
	
	texture_position.x -= speed
	$TextureRect.set_global_position(texture_position)
	offset -= speed
	if offset == -100:
		turn = "right"
	
	pass

func _on_Button_pressed():
	
	var change_scene = true
	if not int($allies_of_you.text):
		$error3.show()
		$Timer.start()
		change_scene = false
	
	if not int($enemies_commander.text):
		$error2.show()
		$Timer.start()
		change_scene = false
	
	if not int($enemies_per_commander.text):
		$error.show()
		$Timer.start()
		change_scene = false
	
	if change_scene:
		
		var loading_instance = load("res://loading.tscn")
		get_tree().change_scene_to(loading_instance)
		
	pass # Replace with function body.

func _on_Timer_timeout():
	
	$error.hide()
	$error2.hide()
	$error3.hide()
	
	pass # Replace with function body.

