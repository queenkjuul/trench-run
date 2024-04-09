extends Area2D

signal hit

export var fire_delay = 0.150
export var speed = 600

var screen_size
var Background

var last_shot_side = 0	# 0 == left, 1 == right
var ms_since_last_shot = fire_delay # ensure we can fire on first frame
var xwing_blast = preload("res://rawAssets/xwing_blast.wav")
var XwingBlast = preload("res://XwingBlast.tscn")
var XwingExplosion = preload("res://Explosion.tscn")
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = (screen_size.x / 2) - 34
	position.y = screen_size.y - 100
	Background = get_tree().root.get_child(0).find_node("Background")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ms_since_last_shot += delta
	if !dead:
		var velocity = Vector2.ZERO
		
		if Input.is_action_pressed("ui_focus_next"):
			_die()
		
		# TODO: Clean this up, build a map of directions and values to iterate over
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_just_pressed("move_left"):
			_set_Background_velocity("x", Background.camera_velocity.x + 200)
		if Input.is_action_just_released("move_left"):
			_set_Background_velocity("x", Background.default_velocity.x)
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_just_pressed("move_right"):
			_set_Background_velocity("x", Background.camera_velocity.x - 200)
		if Input.is_action_just_released("move_right"):
			_set_Background_velocity("x", Background.default_velocity.x)
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_just_pressed("move_up"):
			_set_Background_velocity("y", Background.camera_velocity.y + 200)
		if Input.is_action_just_released("move_up"):
			_set_Background_velocity("y", Background.default_velocity.y)
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_just_pressed("move_down"):
			_set_Background_velocity("y", Background.camera_velocity.y - 200)
		if Input.is_action_just_released("move_down"):
			_set_Background_velocity("y", Background.default_velocity.y)

		if (Input.is_action_pressed("fire") && ms_since_last_shot >= fire_delay) || (Input.is_action_just_pressed("fire") && ms_since_last_shot >= (fire_delay * 0.75)):
			ms_since_last_shot = 0
			$BlasterPlayer.stop()
			$BlasterPlayer.play()
			var newBlaster = XwingBlast.instance()
			newBlaster.position.x = self.position.x + (last_shot_side * 61)
			newBlaster.position.y = self.position.y - 15
			$Blasters.add_child(newBlaster)
			if (last_shot_side == 1):
				last_shot_side = 0
			else:
				last_shot_side = 1
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()
			Background.camera_velocity = Background.default_velocity
			
		position += velocity * delta
		position.x = clamp(position.x, 5, screen_size.x - 68)
		position.y = clamp(position.y, 0, screen_size.y - 80)


func _on_Xwing_body_entered(body):
	_die()


func _on_Xwing_area_entered(area):
	_die()

func _set_Background_velocity(dir, val):
	if Background:
		Background.camera_velocity[dir] = val

func _die():
	$AnimatedSprite.hide()
	$WilhelmPlayer.play()
	dead = true
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionPolygon2D.set_deferred("disabled", true)
	add_child(XwingExplosion.instance())
