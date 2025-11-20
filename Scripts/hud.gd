extends Control

@onready var score_label: Label = %ScoreLabel
@onready var highscore_label: Label = %HighscoreLabel
@onready var life_1: TextureRect = $MarginContainer/HBoxContainer/Life1
@onready var life_2: TextureRect = $MarginContainer/HBoxContainer/Life2
@onready var final_score_label: Label = $GameOverContainer/FinalScoreLabel
@onready var new_high_score_label: Label = $GameOverContainer/NewHighScoreLabel
@onready var game_over_container: VBoxContainer = $GameOverContainer
@onready var level_complete_container: VBoxContainer = $LevelCompleteContainer

var _current_score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.score_update.connect(_on_score_updated)
	GameManager.life_lost.connect(_on_player_life_lost)
	GameManager.game_over.connect(_on_game_over)
	GameManager.level_complete.connect(on_level_complete)
	GameManager.game_started.connect(_on_game_started)
	score_label.text = "Score: %s" % GameManager.current_score
	highscore_label.text = "Highscore: %s" % GameData.high_score


func _on_game_started() -> void:
	life_1.show()
	life_2.show()
	game_over_container.hide()
	level_complete_container.hide()


func _on_score_updated(current_score) -> void:
	_current_score = current_score
	score_label.text = "Score: %s" % current_score


func _on_player_life_lost(current_lives) -> void:
	if current_lives == 2:
		life_1.hide()
	elif current_lives == 1:
		life_2.hide()


func _on_game_over() -> void:
	score_label.text = "Score: %s" % GameManager.current_score
	game_over_container.show()
	final_score_label.text = "Score: %s" % _current_score
	if _current_score > GameData.high_score:
		new_high_score_label.text = "New Highscore: %s" % _current_score
	else:
		new_high_score_label.text = "Highscore: %s" % GameData.high_score


func on_level_complete() -> void:
	level_complete_container.show()
