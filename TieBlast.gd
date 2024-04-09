extends RigidBody2D

export var speed = 1200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.y += speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
