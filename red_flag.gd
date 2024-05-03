extends Area2D

signal captured(winner)
var id = "red_flag"
var coordenate

func set_position(pos):
	global_position = pos
	coordenate = Vector2(pos.x / 30 , pos.y / 30) 
	pass

func _on_red_flag_area_entered(area):
	
	if area.id == "player" or area.id == "your_commander" or area.id == "friend":
		emit_signal("captured",area.id)

	pass # Replace with function body.
