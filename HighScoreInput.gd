extends Control
signal submit

var CHARS = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","Q","X","Y","Z","0","1","2","3","4","5","6","7","8","9","!","@","#","$","%","^","&","*","(",")",":",";"," "]
var current_index = 0
var current_column = 0

var hi_name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_item = $Columns.get_child(current_column)
	var current_name = [$Columns/Column1.text, $Columns/Column2.text, $Columns/Column3.text]
	hi_name = "%s%s%s" % current_name 
	$Columns/End.text = "END"
	current_index = clamp(current_index, 0, CHARS.size() - 1)
	
	if current_column != 3:
		current_item.text = CHARS[current_index]
		if Input.is_action_just_pressed("move_left"):
			current_item.visible = true
			if current_column != 0:
				current_column -= 1
				current_index = clamp(CHARS.find($Columns.get_child(current_column).text), 0, CHARS.size())
		if Input.is_action_just_pressed("move_down"):
			current_item.visible = true
			current_index += 1
		if Input.is_action_just_pressed("move_up"):
			current_item.visible = true
			current_index -= 1
		if Input.is_action_just_pressed("move_right"):
			current_item.visible = true
			current_column += 1
			if current_column <= 2 && current_name[current_column] != "":
				current_index = CHARS.find($Columns.get_child(current_column).text)
		if Input.is_action_just_pressed("ui_accept"):
			current_item.visible = true
			current_column += 1
	else:
		if Input.is_action_just_pressed("move_left"):
			current_column -= 1
			current_index = CHARS.find($Columns.get_child(current_column).text)
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("submit", "%s%s%s" % [$Columns/Column1.text, $Columns/Column2.text, $Columns/Column3.text])
			queue_free()

func _on_Timer_timeout():
	var current_item = $Columns.get_child(current_column)
	current_item.visible = !current_item.visible
