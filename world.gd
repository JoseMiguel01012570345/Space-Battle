extends Node2D

var thread = Thread.new()
var player
var commander
var enemy_soldier 
var player_soldier
var your_commander
var wall
onready var bullet_contact = preload("res://bullet_contact.tscn")
onready var commander_dead = preload("res://commander_dead.tscn")
onready var ship_explotion = preload("res://ship_explotion.tscn")
onready var player_dead = preload("res://player_dead.tscn")
onready var impact = preload("res://impact.tscn")

# ------server---------
var client = StreamPeerTCP.new()
var port = 8000
var host = '127.0.0.1'
var SimulationReady = false
var serverUp = false
var connector = ServerConnector.new()
#---------------------
var screen_size = Vector2()
var playlist = [
	
	preload("res://resource/Sounds/clockwork-chaos-dark-trailer-intro-202223.mp3"),
	preload("res://resource/Sounds/defining-moments-202410.mp3"),
	preload("res://resource/Sounds/dramatic-reveal-21469.mp3"),
	preload("res://resource/Sounds/fight-142564.mp3"),
	preload("res://resource/Sounds/the-epic-trailer-12955.mp3"),
	preload("res://resource/Sounds/the-shield-111353.mp3"),
	preload("res://resource/Sounds/warrior_medium-192841.mp3"),
	preload("res://resource/Sounds/GameSounds/suspense-intro-21472.mp3"),
	preload("res://resource/Sounds/GameSounds/soundtracksong-66467.mp3"),
	preload("res://resource/Sounds/GameSounds/epic-powerful-logo-196229.mp3"),
	preload("res://resource/Sounds/GameSounds/epic-ident-heroic-powerful-intro-logo-196233.mp3"),
	preload("res://resource/Sounds/GameSounds/epic-hybrid-logo-196235.mp3"),
	preload("res://resource/Sounds/GameSounds/epic-dramatic-inspirational-logo-196234.mp3"),
]
var world_map = map.new()
var my_map
var player_state = true
var length_x
var length_y
var time = 100
var list_of_instance_of_enemy_soldiers = []
var list_of_instance_of_player_soldiers = []
var commander_list = []
var left_flag
var right_flag
var last_player_pos = Vector2.ZERO
var Simulation_Ended
var send = preload("res://Button.tscn")
var line_edit = preload("res://LineEdit.tscn")

func GetBlueFlagPosition():
	return $blue_flag.global_position
	
func GetRedFlagPosition():
	return $red_flag.global_position

func GetFriendsSoldiers():
	return list_of_instance_of_player_soldiers
	
func GetEnemySoldiers():
	return list_of_instance_of_enemy_soldiers

func UserLose():
	$Camera2D.position = your_commander.position
	Simulation_Ended = true
	last_player_pos = your_commander.position
	pass
	
func IALose(pos: Vector2):
	$Camera2D.position = pos
	Simulation_Ended = true
	last_player_pos = pos
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size
	client.connect_to_host(host,port)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng = rng.randi_range(0, playlist.size() -1 )
	$background_sound.stream = playlist[rng]
	$background_sound.play()
	
	wall = preload("res://wall_area.tscn")
	commander = preload("res://command.tscn")
	enemy_soldier = preload("res://soldier_command.tscn")
	player_soldier = preload("res://soldier_user.tscn")
	player = preload("res://player.tscn")
	your_commander = preload("res://you_commander.tscn")
	
	#var MAP = [
	#	[true,true,false,false,true,false],
	#	[true,true,false,false,true,false],
	#	[true,true,false,false,true,false],
	#	[true,true,false,false,true,false],
	#	[true,true,false,false,true,false],
	#	[true,true,true,true,true,false],
	#]
	#
	#print(a[0]['action'])
	
	init(  3  , 3 , 1 ) 
	
	connector.SendBuildGraphRequest(my_map,client)
	var player_pos = player.global_position
	player.global_position = Vector2(int(player_pos.x / 30),int(player_pos.y / 30)) * 30 + Vector2(15,15)
	
	pass

func _process(delta): 
	
	
	var status = client.get_status()
	if status == StreamPeerTCP.STATUS_CONNECTED:
		serverUp = true
		if serverUp and not SimulationReady:
			connector.SendBuildGraphRequest( my_map , client)
			SimulationReady = true
			pass
		pass
	else:
		serverUp = false
		pass

	# follow player
	if not Simulation_Ended and $player:
		$TextureRect.set_global_position($player.global_position - (screen_size/2))
		$background_sound.global_position = $player.global_position - (screen_size/2)
		last_player_pos = $player.global_position
	
		pass
	elif Simulation_Ended:
		game_over()
		pass
	else:
		# GAME OVER
		game_over()
		
	pass

func game_over():
	
	$Camera2D.current = true
	$Camera2D.global_position = last_player_pos
	$TextureRect.set_global_position(last_player_pos - (screen_size/2))
	$background_sound.global_position = last_player_pos - (screen_size/2)
		
	var label_game_over = preload("res://label_game_over.tscn")
	var game_over = label_game_over.instance()
	game_over.set_global_position( last_player_pos)
	add_child(game_over)
	
	pass

func quite_map():
	
	var map_size = my_map[0].size() * 30
	
	$left_frontier.set_( Vector2(0,map_size /2) , map_size , 20)
	
	$right_frontier.set_(Vector2( map_size , map_size/2 ) , map_size , 20)
	
	$top_frontier.set_(Vector2( map_size/2 , 0 ) , map_size , 20)
	
	$bottom_frontier.set_( Vector2( map_size /2  , map_size ) , map_size , 20 )
	
	length_x = map_size + 100
	length_y = map_size
	
	pass

func init(commander_number , enemy_soldier_number , player_soldiers_number ):
	
	my_map = world_map.get_map_formatted(10,10,10)
	draw_map(my_map)
	quite_map()  
	
	var flags = draw_flags()
	var blue = flags["blue"]
	var red = flags["red"]
	
	locate_ships( player_soldiers_number , enemy_soldier_number , blue , red , commander_number )
	
	pass

func draw_map(Map):
	
	var x_size = Map[0].size()
	var y_size = Map.size()
	for i in range(x_size):
		for j in range(y_size):
			if not Map[j][i]:
				var wall_block = wall.instance()
				wall_block.global_position = Vector2(i*30 + 15,j*30 + 15)
				add_child(wall_block)
				pass
			pass
		pass
	
	pass

func _on_background_sound_finished():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng = rng.randi_range(0, playlist.size() -1 )
	$background_sound.stream = playlist[rng]
	$background_sound.play()
	
	pass # Replace with function body.

func _on_world_tree_exited():
	connector.killServer(client)
	pass # Replace with function body.

#_____________Flag placement____________
func count_blocks(matrix):
	
	var count = 0
	for item in matrix:
		if item:
			count += 1	
	
	return count

func best_hole( start ):
	
	var best
	var best_matrix
	
	var top_matrix = []
	var center_matrix = []
	var bottom_matrix = []
	
	for i in range( 0, int(my_map.size()/3) ): # row
		var row = []
		for j in range( start , start + int(my_map.size()/3) ):# column
			row.append( my_map[i][j] )
		
		top_matrix.append(row)
	
	for i in range( int(my_map.size()/3) , int(my_map.size()/3) * 2 ): # row
		var row = []
		for j in range( start , start + int(my_map.size()/3) ): #column
			row.append( my_map[i][j] )
		
		center_matrix.append(row)
	
	for i in range( int(my_map.size()/3) * 2, my_map.size() ): # row
		var row = []
		for j in range( start ,  start + int(my_map.size()/3) ): # column
			row.append( my_map[i][j] )
		
		bottom_matrix.append(row)
	
	# select walless matrix in the range
	best = count_blocks(top_matrix)
	best_matrix = { "matrix": top_matrix , "row_offset": 0}
	
	var count2 = count_blocks(center_matrix)
	
	if best < count2:
		best_matrix = { "matrix": center_matrix , "row_offset": int(my_map.size()/3) }
		
	var count3 = count_blocks(bottom_matrix)
	if best< count3:
		best_matrix = { "matrix": bottom_matrix , "row_offset": int(my_map.size()/3)*2 }
	
	return best_matrix

func generate_left_flag(left):
	
	var left_matrix = left["matrix"]
	var left_row_offset = left["row_offset"]
	var posible_positions = []
	
	var current_time_msec = OS.get_ticks_msec()
	
	for i in range( 0 , left_matrix.size()):
		for j in range( 0 , left_matrix[0].size()):
			
			if is_valid_position(left_matrix,i,j):
				
				if left_matrix[i][j] and left_matrix[ i+ 1 ][j] and left_matrix[i][j + 1] and left_matrix[i + 1][j + 1]:
					var left_flag = { "row":i + left_row_offset , "column": j }
					posible_positions.append(left_flag)
	
	return posible_positions[ current_time_msec % posible_positions.size() ]

func generate_right_flag( right ):
	
	var right_matrix = right["matrix"]
	var right_row_offset = right["row_offset"]
	var posible_positions = []
	
	var current_time_msec = OS.get_ticks_msec()
	for i in range( 0 , right_matrix.size()  ) :
		for j in range( 0 , right_matrix[0].size() ) :
			
			if is_valid_position(right_matrix,i,j):
				
				if right_matrix[i][j] and right_matrix[ i+ 1 ][j] and right_matrix[i][j + 1] and right_matrix[i + 1][j + 1]:
					var right_flag = { "row":i + right_row_offset , "column": j +  2 * int(my_map.size()/3)  }
					posible_positions.append(right_flag)
					
	return posible_positions[ current_time_msec % posible_positions.size() ]

func locate_flags():
	
	var left = best_hole(0)
	var left_flag = generate_left_flag(left)
	
	var right = best_hole( int(my_map.size()* 2 / 3) )
	var right_flag = generate_right_flag(right)
	
	return { "left": left_flag, "right": right_flag }

func is_valid_position(matrix , row,column):
	
	return row + 1 < matrix.size() and column + 1 < matrix[0].size()

func draw_flags():
	
	var flags = locate_flags()
	var left_flag = flags["left"]
	var right_flag = flags["right"]
	
	var current_time_msec = OS.get_ticks_msec()
	
	if current_time_msec % 2:
		$red_flag.set_position(Vector2( (left_flag["column"] + 1) * 30, (left_flag["row"] + 1) * 30 ) )
		$blue_flag.set_position(Vector2( (right_flag["column"] + 1) * 30, (right_flag["row"] + 1) * 30 ) )
		
		return {"red":left_flag , "blue": right_flag }
	else:
		$blue_flag.set_position(Vector2( (left_flag["column"]+ 1) * 30, (left_flag["row"] + 1) * 30 ) )
		$red_flag.set_position(Vector2( (right_flag["column"]+ 1 ) * 30, (right_flag["row"] + 1) * 30  ) )
		
		return {"red":right_flag , "blue": left_flag }
	pass

#--------------------------Ship placement___________________
# csp restrictions
func is_valid_ship_position( row,column,matrix ): 
	
	if row - 1 < 0 or row + 1 > matrix.size() - 1 :
		return false
	
	if column - 1 < 0 or column + 1 > matrix[0].size() - 1 :
		return false
	
	for i in range(-1,2):
		for j in range(-1,2):
			
			var matrix_row  = matrix[ row + i]
			var cell = matrix_row[ column + j]
			if not cell :
				return false
			
	return true

func instance_ship(pos, intance_ship_type):
	
	var ship = intance_ship_type.instance()
	add_child(ship)
	ship.start_position( pos , length_x ,length_y )
	
	return ship

func locate_ships( number_ally , number_enemy_per_commander , blue ,red , number_of_commanders):
	
	var map = copy_matrix()
	
	#locate your_commander
	var stack = neighborhood(blue["row"] , blue["column"] ,map , [] )
	var my_commander_result = csp( 1  , map , [] , stack )
	map = my_commander_result["map"]
	var my_boss_pos = my_commander_result["new"]
	var my_commander = draw_ships(my_boss_pos,your_commander)[0]
	
	# locate player
	var user_result = csp( 1 , map , my_commander_result["visited"] , my_commander_result["stack"] )
	var user_pos = user_result["new"]
	map = user_result["map"]
	player = draw_ships(user_pos,player)[0]
	
	# draw and locate user soldiers
	var result = csp( number_ally , map ,user_result["visited"] , user_result["stack"])
	var ally_list = result["new"]
	map = result["map"]
	list_of_instance_of_player_soldiers = draw_ships( ally_list , player_soldier )
	
	# set soldiers to my_commander
	my_commander.my_soldiers = list_of_instance_of_player_soldiers
	your_commander = my_commander
	
	var opponent = [ ]
	stack = neighborhood(red["row"] , red["column"] ,map , [] )
	for command in range(0,number_of_commanders):
		
		# locate commander
		var my_result = csp( 1  , map , [] , stack )
		map = my_result["map"]
		var boss = my_result["new"]
		
		#locate commander soldiers
		var new_result = csp( number_enemy_per_commander , map , my_result["visited"] , my_result["stack"] )
		map = new_result["map"]
		var enemy_list = new_result["new"]
		stack = new_result["stack"]
		
		opponent.append( { "command": boss , "soldiers": enemy_list  } )
	
	#draw enemies
	for group in opponent:
		
		commander_list += draw_ships( group["command"] , commander )
		list_of_instance_of_enemy_soldiers += draw_ships( group["soldiers"] , enemy_soldier )
		
		commander_list[-1].my_soldiers = list_of_instance_of_enemy_soldiers
		pass
	pass

func draw_ships( list_of_ships ,ship_type ):
	
	var list_instance = []
	
	for ship in list_of_ships:
		
		var pos = Vector2( ship["column"] * 30 + 15, ship["row"] * 30 + 15)
		var my_ship = instance_ship( pos, ship_type )
		list_instance.append(my_ship)
		
	return list_instance

func is_visited(row,column,visited):
	
	for cell in visited:
		if cell["row"] == row  and cell["column"] == column:
			return true
	return false

func neighborhood( row , column , matrix , visited):
	
	var neighborhood_matrix = []
	for i in range(-1,2):
		
		if row + i == matrix.size() or row + i < 0: continue
		
		for j in range(-1,2):
			
			if column + j == matrix.size() or column + j < 0 : continue
			
			if matrix[row+i][column+j] and not is_visited(row+i,column+j,visited):
				neighborhood_matrix.append( { "row":row + i ,"column":column + j } )
		
		pass
		
	return neighborhood_matrix

func set_ship_bussy_cells( row,column,matrix ):
	
	for i in range(-1,2):
		for j in range(-1,2):
			matrix[row + i][ column + j ] = false
			
	return matrix

func copy_matrix():
	
	var new_copy = []
	
	for row in my_map:
		var my_row = []
		for column in row:
			my_row.append(column)
		
		new_copy.append(my_row)
	
	return new_copy

func csp( number_ship , map , visited_ , stack_ ):
	
	var visited = visited_
	var new_list = []
	var stack = stack_
	var number_stack = []
	
	while stack.size() > 0 :
		
		if number_ship == 0:
			return {"map": map , "new": new_list , "stack":stack , "visited":visited }
		
		var cell = stack[0]
		if is_valid_ship_position(cell["row"],cell["column"] , map ):
			
			new_list.append(cell)
			
			map = set_ship_bussy_cells( cell["row"] , cell["column"] , map )
			number_ship -= 1
			pass
		
		stack += neighborhood(cell["row"],cell["column"] , map , visited)
		number_stack.append(stack.size())
		
		visited.append(stack[0])
		stack.remove(0)
		
		if stack.size() == 0:
			print("number_stack:",number_stack)
			for i in stack_:
				print(map[i['row']][i['column']])
				pass
		
	print("error")

func _on_UI_send():
	
	ask_ai()
	
	pass # Replace with function body.
	
func ask_ai():
	
	var description = $CanvasLayer/UI.description
	$CanvasLayer/UI.description = ""
	
	var answer = connector.Ask_AI( my_map , my_map.size() , my_map.size() ,description, client )
	
	$CanvasLayer/UI.ai_answer = answer
	$CanvasLayer/UI.answer()
	
	
	pass
