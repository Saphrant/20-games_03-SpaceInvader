extends Area2D

@export var score_value: int

func _on_area_entered(_area: Area2D) -> void:
		GameManager.on_enemy_destroyed(global_position, score_value,"alien")
		queue_free()
