extends Node2D

var host = '127.0.0.1'
var port = 8000
var project_path = ProjectSettings.globalize_path("res://") + "server/main.py"
var server_global_location = project_path
var background_rotation = 0
var rot = 0
var thread = Thread.new()

# Called when the node enters the scene tree for the first time.
func _ready():

	var screen = get_viewport_rect().size
	$loading_bar.set_position( Vector2(screen[0]/2,screen[1]/2 ) )
	OS.execute('py',[server_global_location,host,port],false,[])
	thread.start(self,"start_world")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rot +=PI/7
	$loading_bar.set_rotation(rot)
	pass

func start_world():
	get_tree().change_scene("res://world.tscn")
	pass
	
