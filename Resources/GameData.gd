extends Node

const SAVE_PATH = "user://score.save"
var high_score: int = 0

func _ready() -> void:
	high_score = _load_high_score()

func _load_high_score() -> int:
	# 1. Check if file exists
	if not FileAccess.file_exists(SAVE_PATH):
		return 0
	# 2. Access file, get variables, close file
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var loaded_score = file.get_var()
	file.close()
	return loaded_score

# --- Score Save
func save_new_high_score(new_score: int) -> void:
	if new_score > high_score:
		high_score = new_score
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file:
			file.store_var(high_score) 
			file.close()
