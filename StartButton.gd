extends Button

const AES_KEY = 'b97613b5979c16e6148fd49fc252634b98218e74a5a817fc03a89c055b3d2909'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("start"):
		emit_signal("pressed")
