extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.play()

func _on_AudioStreamPlayer2D_finished():
	get_parent().queue_free() # Replace with function body.
