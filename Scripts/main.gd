extends Node2D

var is_game_over: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_game_over = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameManager.game_over.connect(_on_game_over)

func _on_game_over() -> void:
	is_game_over= true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and is_game_over:
		get_tree().reload_current_scene()
	
