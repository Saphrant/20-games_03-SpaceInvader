extends Node

#----- Game States ----
signal game_started
signal game_over

#----- UI ----
signal level_complete
signal score_update
signal life_lost

#----- GamePlay ----
signal enemy_destroyed

@export var explosion_particle_scene: PackedScene

var current_score := 0
var current_lives := 3

var screen_size:= Vector2(320,224)

func _ready() -> void:
	GameData.high_score = GameData._load_high_score()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

func on_enemy_destroyed(position: Vector2, score_value: int, type) -> void:
	current_score += score_value
	score_update.emit(current_score)
	enemy_destroyed.emit(type)
	AudioManager.on_explosion_sound()
	var explosion_particle = explosion_particle_scene.instantiate() as CPUParticles2D
	explosion_particle.global_position = position
	add_child(explosion_particle)
	explosion_particle.emitting = true
	await explosion_particle.finished
	explosion_particle.queue_free()


func on_life_lost() -> void:
	current_lives -= 1
	life_lost.emit(current_lives)
	AudioManager.on_explosion_sound()
	AudioManager.on_death_sound()
	if current_lives < 1:
		if current_score > GameData.high_score:
			GameData.save_new_high_score(current_score)
		on_game_over()
		AudioManager.on_game_over_sound()


func on_level_complete() -> void:
	level_complete.emit()

func on_game_started() -> void:
	game_started.emit()

func on_game_over() -> void:
	current_lives = 3
	current_score = 0
	game_over.emit()
