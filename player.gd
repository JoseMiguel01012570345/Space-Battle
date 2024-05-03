extends Area2D

var motion = Vector2()
var rotation_head = 0
var limit
var thread =  Thread.new()
var life = 40000
export (PackedScene) var Bullet
var time = 8 # time between every key press of the type ( up, down , left , right )
var id = "player"
var dimention_x
var dimention_y
var targets = ["enemy","commander"]
var enemy_list = []
var enemy_detected = false
var target_to_shot = 0
var target_avaliable = false
var target_timeout = false
var ship_name = "hero"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide()
	$life_tag.set_life(life)
	thread.start(self,"update_enemy_list")
		
	pass

func update_enemy_list():
	
	while true:
		enemy_list.sort_custom(self,"shot_heuristic")
		enemy_list.invert()
		
		OS.delay_msec(500)
	pass

func change_target():

	target_to_shot += 1
	if target_to_shot + 1 >= enemy_list.size():
		target_to_shot = 0
	pass

func face_to_enemy( area:Area2D ):
	
	if area == null: 
		return Vector2(0,0)
	
	var enemy_pos = area.global_position - global_position
	var degree = enemy_pos.normalized().angle()
	
	var direction = $head.global_position - global_position
	
	self.rotation = degree
	rotation_head = degree 
	
	$direction_collision.rotation = -degree

func defend_position(  ):

	var face_now = null
	if enemy_list.size() > target_to_shot:
		face_now = enemy_list[target_to_shot]
	
	face_to_enemy(face_now)
	
	if not target_avaliable and target_timeout:
		
		change_target()
		pass
	
	pass

func Defense():
	
	if enemy_detected :
		defend_position(  )
	
	pass

func no_shot():
	if $shot_eye.is_colliding():
		var tar = $shot_eye.get_collider()
		if  tar.id == "friend" or tar.id == "my_commander" or tar.id == "wall":
			return false
		return true
	return false

func shot_heuristic(area:Area2D):
	return area.global_position.length_squared() * area.life

func change_direction(position,delta):
	
	$AnimatedSprite.animation = "speed1"
	var speed = 200
	
	if Input.is_action_pressed("ui_down") and !$direction_collision.down_is_colliding() :
		if rotation_head == 90:
			$AnimatedSprite.animation = "step_back"
		elif rotation_head == 0 or rotation_head == 360:
			$AnimatedSprite.animation = "desplace_left"
		elif rotation_head == 180:
			$AnimatedSprite.animation = "desplace_right"
		else:
			$AnimatedSprite.animation = "speed3"
		
		motion.y += speed
	
	if Input.is_action_pressed("ui_up") and !$direction_collision.up_is_colliding():
		
		if rotation_head == 270:
			$AnimatedSprite.animation = "step_back"
		elif rotation_head == 0 or rotation_head == 360:
			$AnimatedSprite.animation = "desplace_right"
		elif rotation_head == 180:
			$AnimatedSprite.animation = "desplace_left"
		else:
			$AnimatedSprite.animation = "speed3"
		
		motion.y += - speed
	
	if Input.is_action_pressed("ui_left") and !$direction_collision.left_is_colliding():
		
		if rotation_head == 90:
			$AnimatedSprite.animation = "desplace_right"
		elif rotation_head == 270:
			$AnimatedSprite.animation = "desplace_left"
		elif rotation_head == 0 or rotation_head == 360 :
			$AnimatedSprite.animation = "step_back"
		else:
			$AnimatedSprite.animation = "speed3"
			
		motion.x += - speed
	
	if Input.is_action_pressed("ui_right") and !$direction_collision.right_is_colliding():
		
		if rotation_head == 90:
			$AnimatedSprite.animation = "desplace_left"
		elif rotation_head == 270:
			$AnimatedSprite.animation = "desplace_right"
		elif rotation_head == 180 :
			$AnimatedSprite.animation = "step_back"
		else:
			$AnimatedSprite.animation = "speed3"
			
		motion.x +=  speed
	
	position += motion * delta
	
	#position.x = clamp(position.x , 50 , dimention_x  )  
	#position.y = clamp(position.y , 0 , dimention_y  ) 

	return position 

func fill_life():
	
	if life < 400 and time == 0:
		life += 0.5
	
	pass   

func change_time():
	
	if time == 0 : 
		time = 8
		pass
	else: 
		time -= 1

	pass

func _physics_process(delta):
	
	Defense()

	motion = Vector2()
	
	$life_tag.set_life(life)

	position =  change_direction(position,delta)

	fill_life()

	shot()
	
	change_time()
	
	target_timeout = false
	
	pass

func start_position(pos , dimention_x , dimention_y ):
	
	position = pos
	show()
	$explotion.hide()
	$CollisionShape2D.disabled = false
	$ship_collision.hide()
	
	self.dimention_x = dimention_x
	self.dimention_y = dimention_y
	
	pass

func shot():
	
	if Input.is_action_just_pressed("space"):
		
		var my_shot = Bullet.instance()
		get_tree().current_scene.add_child(my_shot) # set the bullet as child of world
	
		my_shot.rotate(rotation) # give rotation bullet
		my_shot.position = $head.global_position # give postion to bullet
	
		my_shot.set_direction() #shot
		
		pass
	pass

func ship_explotion():
	
	$ship_collision.global_position = position
	$ship_collision.show()
	$AnimatedSprite.hide()
	$ship_collision_animation.play("destruction")
	$CollisionShape2D.call_deferred("set", "disabled", true)
	pass

func rocket_explotion():
	
	$explotion.global_position= position
	$explotion.show()
	$explotion_animation.play("explotion")	
	
	pass

func destroy_sound():
	
	var player_dead = get_parent().player_dead.instance()
	add_child(player_dead) 
	player_dead.play()
	pass

func _on_player_area_entered(area):

	#if area.id == "enemy":
	#	ship_explotion()
	#	destroy_sound()
	#elif area.id == "friend":
	#	ship_explotion()
	#	destroy_sound()
	#elif area.id == "commander":
	#	ship_explotion()
	#	destroy_sound()
	#elif area.id == "my_commander":
	#	ship_explotion()
	#	destroy_sound()
	if area.id == "bullet":
		life -= 20
		rocket_explotion()
		area.queue_free()
		var impact = get_parent().impact.instance()
		add_child(impact) 
		impact.play()
	elif area.id == "red_flag":
		
		get_tree().current_scene.your_commander.flag_found = true
		get_tree().current_scene.your_commander.flag_position = area.coordenate
		
	if life <= 0 :
		ship_explotion()
		destroy_sound()
	
	pass # Replace with function body.	

func _on_ship_collision_animation_animation_finished(anim_name):
	get_parent().call_deferred("remove_child",self)
	pass # Replace with function body.

func _on_explotion_animation_animation_finished(anim_name):
	$explotion.hide()
	pass # Replace with function body.

func _on_direction_collision_restart_position():
	
	global_position = $direction_collision.last_avaliable_pos
	
	pass # Replace with function body.

func _on_radar_area_entered(area):

	for item in targets:
		
		if item == area.id:
			enemy_list.append( area )
			enemy_detected = true
		
	pass # Replace with function body.

func _on_radar_area_exited(area):
	
	var i =0
	while i < enemy_list.size():
		
		if str(area.ship_name) == str(enemy_list[i].ship_name):
			if i < target_to_shot:
				target_to_shot -=1
			enemy_list.remove(i)
			break
		i += 1

	pass # Replace with function body.

func _on_target_detection_timeout():
	
	target_timeout = true
	if no_shot():
		target_avaliable = true
	else:
		target_avaliable = false
	
	pass # Replace with function body.
