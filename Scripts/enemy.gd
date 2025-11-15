extends Area2D

signal enemy_death

@export_category("Specific Enemy Properties")
@export var award_score:= 10
	
func _on_area_entered(_area: Area2D) -> void:
		enemy_death.emit()
		queue_free()
