extends Control

var description = ""
signal send
var ai_answer = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func answer():
	$TextEdit.text = ai_answer
	pass

func _on_Button_pressed():
	
	description = $LineEdit.text
	emit_signal("send")
	
	pass # Replace with function body.
