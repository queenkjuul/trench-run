extends Node2D

var move_speed = 60

var alpha = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	alpha = alpha - delta
	self.position.y -= (move_speed * delta)
	$Label.add_color_override("font_color", Color(1,1,1, alpha))
	if alpha <= 0:
		queue_free()
