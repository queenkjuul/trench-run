extends Area2D

signal hit

export var speed = 300
export var h_speed = 200
export var fire_delay = 0.7
export var turn_delay = 0.4

var screen_size

var TieExplosion = preload("res://TieExplosion.tscn")
var TieBlast = preload("res://TieBlast.tscn")
var dead = false
var ms_since_last_shot = 0.5
var ms_since_dir_change = 0
var last_shot_side
var h_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = randi() % int(screen_size.x)
	position.y = -30
	if randi() % 2 == 0:
		h_dir = 1
		last_shot_side = 0
	else:
		h_dir = -1
		last_shot_side = 1

# Called every frame. 'delta' is the elapsed time since the previous framase.
func _process(delta):
	if !dead:
		ms_since_dir_change += delta
		ms_since_last_shot += delta
		position.y += speed * delta
		position.x += h_speed * delta * h_dir
		position.x = clamp(position.x, 8, screen_size.x - 40)
		if ms_since_dir_change >= turn_delay && (randi() % 90 == 0):
			ms_since_dir_change = 0
			if h_dir == 1:
				h_dir = -1
			else:
				h_dir = 1
		if position.x >= screen_size.x - 40:
			h_dir = -1
		if position.x <= 8:
			h_dir = 1
		if ms_since_last_shot > fire_delay && (randi() % 65 == 0) && position.y < (screen_size.y / 2):
			_fire_shot($Blasters/BlasterSound1)
			_fire_shot($Blasters/BlasterSound1)
			$Blasters/Timer.start()

func _on_VisibilityNotifier2D_screen_entered():
		$AudioStreamPlayer2D.play()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Tie_body_entered(body):
	_die()
	body.queue_free()

func _fire_shot(blaster_sound):
	ms_since_last_shot = 0
	var new_blaster = TieBlast.instance()
	new_blaster.position.x = self.position.x - 10 + (last_shot_side * 20)
	new_blaster.position.y = self.position.y + 45
	$Blasters.add_child(new_blaster)
	blaster_sound.stop()
	blaster_sound.play()
	if (last_shot_side == 1):
		last_shot_side = 0
	else:
		last_shot_side = 1

func _on_Timer_timeout():
	_fire_shot($Blasters/BlasterSound2)
	_fire_shot($Blasters/BlasterSound2)

func _on_Tie_area_entered(area):
	if "Xwing" in area.name:
		_die()

func _die():
	$AnimatedSprite.hide()
	emit_signal("hit", position)
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionPolygon2D.set_deferred("disabled", true)
	if !dead:
		add_child(TieExplosion.instance())
	dead = true
