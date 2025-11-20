extends Area2D

@export var bullet_speed := 400

func _physics_process(delta: float) -> void:
	global_position += Vector2.UP * bullet_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("player"):
		queue_free()
