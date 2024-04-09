extends RigidBody2D

export var speed = 2100
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	velocity.y = -1
	velocity = velocity.normalized() * speed
	global_position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_XwingBlast_body_entered(body):
	queue_free() # Replace with function body.
