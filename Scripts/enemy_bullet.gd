extends Area2D

@export var bullet_speed := 100

func _physics_process(delta: float) -> void:
	global_position += Vector2.DOWN * bullet_speed * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
