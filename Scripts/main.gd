extends Node2D

const SAVE_PATH = "user://score.save"

@export var level_scene: PackedScene

var current_highscore:int
var is_game_started: bool
var current_level_node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_game_started = false
	#GameManager.game_start_request.connect(_on_game_start_request)
	#GameManager.game_over.connect(_on_game_over)
	#GameManager.quit_game.connect(_on_game_quit)
	#GameManager.score_animations_finished.connect(_on_score_animations_finished)
	current_highscore = player_load()
	_on_game_start_request(false)
	
func _on_game_start_request(is_new_game: bool) -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if is_new_game:
		if FileAccess.file_exists(SAVE_PATH):
			DirAccess.remove_absolute(SAVE_PATH)
			
	if is_instance_valid(current_level_node):
		current_level_node.queue_free()
	current_level_node = level_scene.instantiate()
	add_child(current_level_node)	



# --- Player Save/Load
func player_save() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(current_highscore)
	file.close()


func player_load() -> int:
	# 1. Check if file exists
	if not FileAccess.file_exists(SAVE_PATH):
		return 0
	# 2. Access file, get variables, close file
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var loaded_score = file.get_var()
	file.close()
	return loaded_score
