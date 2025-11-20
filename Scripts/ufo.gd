extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var left_spawn: Marker2D = $LeftSpawn
@onready var right_spawn: Marker2D = $RightSpawn
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var max_speed := 100.0
@export var min_score: int
@export var max_score: int
var direction: Vector2

var spawn_markers: Array
var spawn_location: Marker2D

var screen_size: Vector2

var has_spawned:= false
var is_on_screen:= false


func _ready() -> void:
	screen_size = get_viewport_rect().size
	collision_shape_2d.disabled = true
	self.global_position = Vector2.ZERO
	direction = Vector2.ZERO
	has_spawned = false


func _physics_process(delta: float) -> void:
	if self.position.x > 0 or self.position.x < screen_size.x:
		is_on_screen = true
	if has_spawned:
		self.position.x += direction.x * max_speed * delta


func _spawn_ufo() -> void:
	spawn_markers = [left_spawn, right_spawn]
	spawn_location = spawn_markers.pick_random()
	self.position = spawn_location.position
	if spawn_location == left_spawn:
		direction.x = 1
	elif spawn_location == right_spawn:
		direction.x = -1
	collision_shape_2d.disabled = false
	has_spawned = true	


func _on_spawn_chance_timer_timeout() -> void:
	var rng = randf()
	if rng < 0.1:
		if !has_spawned:
			_spawn_ufo()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true
	audio_stream_player_2d.play()
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_on_screen:
		collision_shape_2d.set_deferred("disabled", true)
		self.global_position = Vector2.ZERO
		direction = Vector2.ZERO
		has_spawned = false
		audio_stream_player_2d.stop()
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		GameManager.on_enemy_destroyed(global_position,randi_range(min_score, max_score), "ufo")
		collision_shape_2d.set_deferred("disabled", true)
		self.global_position = Vector2.ZERO
		direction = Vector2.ZERO
		has_spawned = false
