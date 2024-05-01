extends Area2D

var motion = Vector2()
var rotation_head = 0
var limit
var thread =  Thread.new()
var life = 300
var Bullet = preload("res://bullet.tscn")
var id = "friend"
var dimention_x
var dimention_y 
var enemy_detected = false
var shot_avaliable = false
var ship_name
var time = 0 # time between every key press of the type ( up, down , left , right )
signal killed
var enemy_list = []
var ally = []
var targets = ["enemy","commander"]
var ally_detection = ["friend","my_commander","player"]
var client: StreamPeerTCP = null
var server_connector = ServerConnector.new()
var my_flag_position: Vector2 = Vector2(0,0)
var Map: Array = []
var brain = Brain.new()

var StateCloser = false
var StateEvadeStarted = false
var StateEvading = false
var StateFar = true
var StateDefensive = false
var InstructionsStack = []
var targetObject
var targetPosition: Vector2
var HasTarget = false
var HasInstruction = false
var PathHistory = []
var target_to_shot = 0
var target_avaliable = false
var target_timeout = false

func SetInstructions(instructions: Array):
	HasInstruction = false
	InstructionsStack = instructions
	pass

func SetTargetPosition(position: Vector2):
	
	targetPosition = position * 30
	StateDefensive = true
	HasTarget = false
	pass

func SetTargetObject(object):
	
	targetObject = object
	StateDefensive = false
	HasTarget = true
	pass

func GetVectorToTargetObject():
	return targetObject.global_position - global_position
	
func GetVectorToTargetPosition():
	return targetPosition - global_position
	
func GetAction(vector: Vector2):
	
	var degree = rad2deg(vector.angle())
	if degree < 45 or degree >= 315:
		return 'right'
	if degree < 135 and degree >= 45:
		return 'down'
	if degree < 0:
		return 'left'
	return 'up'

func FollowInstructions():
	var instruction = InstructionsStack[0]
	if not HasInstruction:
		if instruction == 'right':
			targetPosition = global_position + Vector2(30,0)
			pass
		elif instruction == 'up':
			targetPosition = global_position + Vector2(0,-30)
			pass
		elif instruction == 'down':
			targetPosition = global_position + Vector2(0,30)
			pass
		else:
			targetPosition = global_position + Vector2(-30,0)
			pass
		pass
	
	var direction = GetVectorToTargetPosition().normalized()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			direction = Vector2(-1,0)
			pass
		else:
			direction = Vector2(1,0)
			pass
		pass
	elif abs(direction.x) < abs(direction.y):
		if direction.y < 0:
			direction = Vector2(0,-1)
			pass
		else:
			direction = Vector2(0,1)
			pass
		pass
	else:
		direction = Vector2(0,0)
		pass
		
	if direction.x == 0 and direction.y == 0:
		$AnimatedSprite.animation = "speed1"
		InstructionsStack.pop_at(0)
		HasInstruction = false
		pass
	else:
		HasInstruction = true
		pass
	change_direction(instruction,1,1)
	pass
	
func EvadeShip(ship):
	if ship_name < ship.ship_name:
		var instructions = InstructionsStack
		var i = 0
		while i < 5 and i < instructions.size():
			instructions[i] = InstructionInverted(instructions[i])
			i += 1
			pass
		ship.SetInstructions(instructions)
		pass
	pass

func InstructionInverted(instruction):
	if instruction == 'up':
		return 'down'
	if instruction == 'down':
		return 'up'
	if instruction == 'left':
		return 'right'
	return 'left'

# Called when the node enters the scene tree for the first time.
func _ready():
	
	client = get_tree().current_scene.client
	my_flag_position = get_tree().current_scene.GetBlueFlagPosition()
	my_flag_position = Vector2(int(my_flag_position.x / 30), int(my_flag_position.y / 30))
	Map = get_tree().current_scene.my_map
	hide()
	$life_tag.set_life(life)
	
	ship_name = id.hash()
	
	pass

func update_enemy_list():
	
	while true:
		enemy_list.sort_custom(self,"shot_heuristic")
		enemy_list.invert()
		
		OS.delay_msec(500)
	pass
	
func change_time():
	
	if time == 0 : 
		pass
	else: 
		time -= 1

	pass

func change_direction(action,x=30,y=30):
	
	if action == 'left' and $direction_collision.left_is_colliding():
		InstructionsStack.pop_at(0)
		HasInstruction = false
		pass
	
	if action == 'up' and $direction_collision.up_is_colliding():
		HasInstruction = false
		InstructionsStack.pop_at(0)
		pass
		
	if action == 'right' and $direction_collision.right_is_colliding():
		HasInstruction = false
		InstructionsStack.pop_at(0)
		pass
		
	if action == 'down' and $direction_collision.down_is_colliding():
		HasInstruction = false
		InstructionsStack.pop_at(0)
		pass
		
	if action == "down" and time == 0  and not $direction_collision.down_is_colliding() :
		motion.y += y
		pass
	if action == "up" and time == 0 and not $direction_collision.up_is_colliding():
		motion.y += - y
		pass
	if action == "left" and time == 0 and not $direction_collision.left_is_colliding():
		motion.x += - x
		pass
	if action == "right" and time == 0 and not $direction_collision.right_is_colliding():
		motion.x += x
		pass
	global_position += motion
	position += motion
	
	var left_overflow = false
	var right_overflow = false
	var up_overflow = false
	var down_overflow = false
	while global_position.x < 0:
		global_position += Vector2(1,0)
		left_overflow = true
		pass
	while global_position.y < 0:
		up_overflow = true
		global_position += Vector2(0,1)
		pass
	while global_position.x >= dimention_x:
		global_position -= Vector2(1,0)
		right_overflow = true
		pass
	while global_position.y >= dimention_y:
		global_position -= Vector2(0,1)
		down_overflow = true
		pass
	
	if left_overflow and action == 'left':
		InstructionsStack.pop_at(0)
		pass
	elif right_overflow and action == 'right':
		InstructionsStack.pop_at(0)
		pass
	elif up_overflow and action == 'up':
		InstructionsStack.pop_at(0)
		pass
	elif down_overflow and action == 'down':
		InstructionsStack.pop_at(0)
		pass
	
	#position.x = clamp(position.x , 50 , dimention_x  )
	#position.y = clamp(position.y , 0 , dimention_y  ) 
	return position 

func change_target():
	
	target_to_shot += 1
	if target_to_shot >= enemy_list.size():
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
	
	return direction

func defend_position(  ):
	
	var face_now = null
	if enemy_list.size() > target_to_shot:
		face_now = enemy_list[target_to_shot]
	
	var direction = face_to_enemy(face_now)
	
	if shot_avaliable and target_avaliable:
		shot()
		shot_avaliable = false
	
	elif not target_avaliable and target_timeout:
		
		change_target()
		pass
	
	pass

func Defense():
	
	if enemy_detected :
		defend_position(  )
	
	pass
	
func Attack():
	var direction: Vector2 = GetVectorToTargetObject()
	if direction.length_squared() < 150:
		StateCloser = true
		StateEvading = false
		StateEvadeStarted = false
		pass
	elif direction.length_squared() < 300:
		StateCloser = false
		StateFar = false
		if not StateEvadeStarted:
			StateEvadeStarted = true
			pass
		else:
			StateEvading = true
			pass
		pass
	elif direction.length_squared() > 450:
		StateEvadeStarted = false
		StateEvading = false
		StateFar = true
		pass
	
	if StateCloser:
		change_direction(GetAction(direction * -1),0,0)
		pass
	
	if StateFar:
		change_direction(GetAction(direction),0,0)
		pass
		
	pass

func StateDefending():
	var defensive_position = Vector2(int(rand_range(-10,10)),int(rand_range(-10,10))) + my_flag_position
	if defensive_position.x < 0:
		defensive_position = Vector2(0,defensive_position.y)
		pass
	if defensive_position.x >= Map[0].size():
		defensive_position = Vector2(Map[0].size() - 1,defensive_position.y)
		pass
	if defensive_position.y < 0:
		defensive_position = Vector2(defensive_position.x,0)
		pass
	if defensive_position.y >= Map.size():
		defensive_position = Vector2(defensive_position.x,Map.size() - 1)
		pass
	
	var my_position = Vector2(int(global_position.x / 30),int(global_position.y / 30))
	if abs(my_position.x - my_flag_position.x) + abs(my_position.y - my_flag_position.y) > 30:
		defensive_position = my_flag_position
		pass
	var defensive_path = server_connector.GetPathTo(my_position,defensive_position,[],client)
	var instructions = brain.TranslatePathToInstrucions(defensive_path)
	return instructions

func MakeAction():
	if InstructionsStack.size() > 0:
		FollowInstructions()
		pass
	elif StateDefensive:
		var instructions = StateDefending()
		SetInstructions(instructions)
		pass
	else:
		StateDefensive = false
		pass
	pass
	
func no_shot():
	if $shot_eye.is_colliding():
		var tar = $shot_eye.get_collider()
		if  tar.id == "player" or tar.id == "friend" or tar.id == "my_commander" or tar.id == "wall":
			return false
		return true
	return false

func fill_life():
		
	if life < 300 and time == 0:
		life += 0.5
	
	pass

func _physics_process(delta):
	
	motion = Vector2()
	
	$life_tag.set_life(life)
	
	fill_life()
	
	change_time()
	
	MakeAction()
	
	Defense()
	
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

func shot( ):
		
	var my_shot = Bullet.instance()
	get_tree().current_scene.add_child(my_shot) # set the bullet as child of world
	
	my_shot.rotate(rotation) # give rotation bullet
	my_shot.position = $head.global_position # give postion to bullet
	
	my_shot.set_direction() #shot
	
	pass

func ship_explotion():
	
	$ship_collision.global_position = position
	$ship_collision.show()
	$AnimatedSprite.hide()
	$ship_collision_animation.play("destruction")
	$CollisionShape2D.call_deferred("set", "disabled", true)
	emit_signal("killed")
	
	pass

func rocket_explotion():
	
	$explotion.global_position= position
	$explotion.show()
	$explotion_animation.play("explotion")	
	
	pass

func destroy_sound():
	
	var ship_explotion = get_parent().ship_explotion.instance()
	add_child(ship_explotion) 
	ship_explotion.play()
	pass

func _on_soldier_user_area_entered(area):
	
	if area.id == "enemy":
		EvadeShip(area)
		pass
	elif area.id == "commander":
		#EvadeShip(area)
		pass
	elif area.id == "player":
		#SetInstructions([])
		#HasInstruction = false
		#EvadeShip(area)
		pass
	elif area.id == "my_commander":
		#EvadeShip(area)
		pass
	elif area.id == 'friend':
		EvadeShip(area)
		pass
	elif area.id == "bullet":
		life -= 20
		rocket_explotion()
		area.queue_free()
		var impact = get_parent().impact.instance()
		add_child(impact) 
		impact.play()
		pass
	elif area.id == 'red_flag':
		get_tree().current_scene.your_commander.flag_found = true
		get_tree().current_scene.your_commander.flag_position = area.coordenate
		pass
		
	if life <= 0 :
		ship_explotion()
		destroy_sound()
		var friends = get_tree().current_scene.your_commander.my_soldiers
		var i = 0
		while i < friends.size():
			if friends[i].ship_name == ship_name:
				friends.pop_at(i)
				break
			i += 1
			pass
	pass # Replace with function body.

func _on_ship_collision_animation_animation_finished(anim_name):
	get_parent().call_deferred("remove_child",self)
	pass # Replace with function body.

func _on_explotion_animation_animation_finished(anim_name):
	$explotion.hide()
	pass # Replace with function body.

func _on_attack_rate_timeout():
	shot_avaliable = true
	pass # Replace with function body.

func shot_heuristic(area:Area2D):
	return area.global_position.length_squared() * area.life

func _on_radar_area_entered(area):
	
	for item in targets:
			
			if item == area.id:
				enemy_list.append( area )
				enemy_detected = true
				
	for item in ally_detection:
			
		if item == area.id:
			ally.append( area )
	
		pass # Replace with function body.

func _on_radar_area_exited(area):

	var i =0
	while i < enemy_list.size():
		
		if str(area.ship_name) == str(enemy_list[i].ship_name):
			enemy_list.remove(i)
			if i < target_to_shot:
				target_to_shot -=1
			i -= 1
		i += 1
	
	i = 0
	while i < ally.size():
		
		if str(area.ship_name) == str(ally[i].ship_name):
			ally.remove(i)
			i -= 1
		i += 1
	pass # Replace with function body.

func _on_direction_collision_restart_position():
	global_position = $direction_collision.last_avaliable_pos
	pass # Replace with function body.

func _on_target_detection_timeout():
	
	target_timeout = true
	if no_shot():
		target_avaliable = true
	else:
		target_avaliable = false
	
	pass # Replace with function body.
