extends Node

const RSA_KEY = '042b4109353974419be9c16c112c4634c8c0a20bd45181babd70223de61d970a'

var score
var lives
var time
var level
var since_last_tie # early levels might have long waits between spawns
var extra_lives

var extra_lives_multiple = 50000
var high_score = 50000

var Tie = preload("res://Tie.tscn")
var Xwing = preload("res://Xwing.tscn")
var PopupScore = preload("res://PopupScore.tscn")
var HighScoreInput = preload("res://HighScoreInput.tscn")

var _difficulty

var playing = false

func _ready():
	randomize()
	$GameOverLabel.hide()
	$LivesSprite.hide()
	$HighScore.text = "%s" % high_score
	$HighScoreClient.getHighScore()

func _process(delta):
	if playing: 
		if Input.is_action_pressed("ui_focus_prev"):
			score = 50001
			lives = -1
			pass
		$StartButton.hide()
		$StartButton.disabled = true
		since_last_tie += delta
		time += delta
		_difficulty = int(500 / time)
		$Score.text = "%s" % score
		level = int((50 / _difficulty) + 1)
		$Level.text = "%s" % level
		if score >= (extra_lives * extra_lives_multiple):
			extra_lives += 1
			lives += 1
			$ExtraLifeSoundPlayer.play()
		$LivesLabel.text = "x %s" % lives

func _on_TieTimer_timeout():
	if randi() % _difficulty == 0 || since_last_tie >= 2:
		since_last_tie = 0
		var new_tie = Tie.instance()
		new_tie.connect("hit", self, "_on_Tie_hit")
		$Ties.add_child(new_tie)

func _on_Xwing_hit():
	lives -= 1
	$ScoreTimer.stop()
	$LevelTimer.stop()
	if lives < 0:
		_game_over()
	else:
		$RespawnTimer.start()

func _on_Tie_hit(popup_position):
	var target_score = clamp(900 + (100 * level), 0, 2000)
	score += target_score
	var popup = PopupScore.instance()
	popup.position = popup_position 
	popup.get_child(0).text = "%s" % target_score
	add_child(popup)
	
func _game_over():
	playing = false
	lives = 0
	_clear_ties()
	$TieTimer.stop()
	$GameOverLabel.show()
	if score > high_score:
		high_score = score
	if score > extra_lives_multiple:
		_show_high_score_input()
	else:
		$StartButton.show()
		$StartButton.disabled = false
	$HighScore.text = "%s" % high_score
	print_debug("you lose")

func _new_game():
	_clear_screen()
	score = 0
	lives = 3
	time = 1
	level = 0
	since_last_tie = 3
	extra_lives = 1
	_difficulty = 1
	_spawn_player()
	$ScoreTimer.start()
	$LevelTimer.start()
	$TieTimer.start()
	$Controls.hide()
	$GameOverLabel.hide()
	$Logo.hide()
	$StartButton.hide()
	$StartButton.disabled = true
	$LivesSprite.show()
	playing = true
	
func _on_RespawnTimer_timeout():
	_clear_screen()
	_spawn_player()
	$TieTimer.start()
	$ScoreTimer.start()
	$LevelTimer.start()

func _on_ScoreTimer_timeout():
	score += int(time / 10) + 1

func _on_LevelTimer_timeout():
	$Level.text = "%s" % level
	
func _clear_ties():
	for child in $Ties.get_children():
		child.queue_free()

func _clear_player():
	for child in $Player.get_children():
		child.queue_free()

func _clear_screen():
	_clear_ties()
	_clear_player()
		
func _spawn_player():
	var player = Xwing.instance()
	player.connect("hit", self, "_on_Xwing_hit")
	$Player.add_child(player)

func _on_StartButton_pressed():
	if !playing && !$HighScoreInput:
		_new_game()

func _on_HighScoreInput_submit(hi_name):
	$StartButton.show()
	$StartButton.disabled = false
	$Logo.show()
	$HighScoreClient.submitScore(hi_name, score, level)
		
func _show_high_score_input():
	$StartButton.disabled = true
	$StartButton.hide()
	var new_hsi = HighScoreInput.instance()
	new_hsi.connect("submit", self, "_on_HighScoreInput_submit")
	add_child(new_hsi)

func _on_HighScoreClient_new_high_score(new_score):
	if new_score > high_score:
		high_score = new_score
	$HighScore.text = "%s" % high_score
