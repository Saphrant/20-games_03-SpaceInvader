extends Node

#----- Game States ----
signal game_start_request
signal game_started
signal game_paused
signal level_complete
signal game_over

#----- UI ----
signal score_update
signal high_score_update
signal life_update
signal life_lost

#----- GamePlay ----
signal enemy_amount
signal bullet_exist

var current_score := 0
var current_highscore := 0
var current_lives := 3
var current_level := 1

var screen_size:= Vector2(320,224)

func _ready() -> void:
	pass

func on_new_level() -> void:
	current_level += 1
	level_complete.emit(current_level)

func on_bullet_destroyed() -> void:
	# Does bullet exist?
	bullet_exist.emit(false)
