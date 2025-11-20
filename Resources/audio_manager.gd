extends Node

@onready var explosion: AudioStreamPlayer = $Explosion
@onready var explosion_2: AudioStreamPlayer = $Explosion2
@onready var music: AudioStreamPlayer = $Music
@onready var death: AudioStreamPlayer = $Death
@onready var game_over: AudioStreamPlayer = $GameOver


func on_explosion_sound() -> void:
	explosion.pitch_scale = randf_range(0.8,1.1)
	explosion.play()
	explosion_2.play()

func on_death_sound() -> void:
	death.play()

func on_game_over_sound() -> void:
	game_over.play()
