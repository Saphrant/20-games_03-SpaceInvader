extends Node2D

@onready var move_timer: Timer = $MoveTimer
@onready var enemy_parent: Node = $Enemies
@onready var reload_timer: Timer = $ReloadTimer
@onready var respawn_timer: Timer = $RespawnTimer

@export_category("Enemies")
@export var jelly_fish_scene : PackedScene
@export var crab_scene : PackedScene
@export var squid_scene : PackedScene

@export_category("Bullet Scene")
@export var bullet_scene : PackedScene

@export_category("Difficulty Curve")
@export var difficulty_curve: Curve

# How columns and rows of each enemy type to spawn
var enemy_size = Vector2(16,16)
var enemy_type_columns:= 11
var enemy_type_rows:= 2
var bullet_array: Array = []

# Spawning logic
var col_padding:= 8
var row_padding:= 8
var screen_size
var screen_middle
var screen_padding:= 55

var move_direction:= 1
var enemies_remaining_count := 0
var max_enemies: int

var min_wait_time:= 0.2
var max_wait_time:= 0.5
var wait_time_fast:= 0.05

var game_over: bool
var has_reloaded: bool
var current_level:= 0


func _ready() -> void:
	GameManager.enemy_destroyed.connect(_on_enemy_death)
	GameManager.life_lost.connect(_on_player_death)
	GameManager.game_over.connect(_on_game_over_cleanup)
	screen_size = get_viewport_rect().size
	screen_middle = screen_size / 2
	_spawn_enemy(current_level)
	has_reloaded = true


func _spawn_enemy(level_spawn_offset) -> void:
	game_over = false
	level_spawn_offset = enemy_size.y * current_level
	var enemy_type := [
	squid_scene,
	crab_scene,
	jelly_fish_scene
	]
	var starting_pos_x = (screen_middle.x + enemy_size.x/2) - ((enemy_size.x * enemy_type_columns) + (col_padding * (enemy_type_columns - 1))) / 2 #Finds the group X middle
	var starting_pos_y = screen_middle.y - (((enemy_size.y + row_padding) * enemy_type_rows) * 3) / 2 #Finds the group Y middle
	var starting_pos = Vector2(starting_pos_x, ((starting_pos_y - 50)+level_spawn_offset))
	#Looping through rows
	for y in range(enemy_type_rows * 3):
		# Looping throuhg columns
		for x in range(enemy_type_columns):
			@warning_ignore("integer_division")
			var	enemy_to_spawn = enemy_type[(y / enemy_type_rows)]
			var enemy = enemy_to_spawn.instantiate()
			enemy.position = Vector2(x * (enemy_size.x + col_padding), y * (enemy_size.y + row_padding))
			enemy_parent.call_deferred("add_child", enemy)
			enemies_remaining_count += 1

	enemy_parent.global_position = starting_pos
	max_enemies = enemies_remaining_count
	move_timer.start()
	GameManager.on_game_started()


func _shoot() -> void:
	var	remaining_enemy_array = enemy_parent.get_children()
	if !remaining_enemy_array.is_empty():
		var attacking_enemy = enemy_parent.get_children().pick_random()
		var bullet = bullet_scene.instantiate() as Area2D
		bullet.global_position = attacking_enemy.global_position
		add_child(bullet)
		bullet_array.append(bullet)
	
	
func _on_move_timer_timeout() -> void:
	var	remaining_enemy_array = enemy_parent.get_children()
	if !remaining_enemy_array.is_empty():
		var min_x_so_far = remaining_enemy_array[0].global_position.x
		var max_x_so_far = remaining_enemy_array[0].global_position.x
		for i in remaining_enemy_array:
			if i.global_position.x < min_x_so_far:
				min_x_so_far = i.global_position.x
			if i.global_position.x > max_x_so_far:
				max_x_so_far = i.global_position.x
		var visual_left_edge = min_x_so_far - (enemy_size.x / 2)
		var visual_right_edge = max_x_so_far + (enemy_size.x / 2)
		if visual_left_edge < screen_padding and move_direction == -1:
			enemy_parent.global_position.y += enemy_size.y
			move_direction = 1
		elif visual_right_edge > screen_size.x - screen_padding and move_direction == 1:
			enemy_parent.global_position.y += enemy_size.y
			move_direction = -1
		else:
			enemy_parent.global_position.x += move_direction * enemy_size.x
	_update_difficulty()
			
		
func _on_shoot_timer_timeout() -> void:
	var rng = randf()
	if rng < 0.4 and has_reloaded:
		_shoot()


func _on_enemy_death(type) -> void:
	if type == "alien":
		enemies_remaining_count -= 1
		if enemies_remaining_count < 1 and !game_over:
			_on_level_complete()
			GameManager.on_level_complete()

func _on_player_death(_arg) -> void:
	has_reloaded = false
	reload_timer.start()
	for bullet in bullet_array:
		if is_instance_valid(bullet):
			bullet.queue_free()
	

func _update_difficulty() -> void:
	var normalized_input:= float(enemies_remaining_count) / float(max_enemies)
	var curve_output:= difficulty_curve.sample(normalized_input)
	var new_wait_time: float = lerp(min_wait_time, max_wait_time,curve_output)
	move_timer.wait_time = new_wait_time
	if enemies_remaining_count <= 1:
		move_timer.wait_time = wait_time_fast
	
func _on_game_over_cleanup() -> void:
	_cleanup()

func _on_reload_timer_timeout() -> void:
	has_reloaded = true

func _on_level_complete() -> void:
	current_level += 1
	_cleanup()
	respawn_timer.start()

			
func _cleanup() -> void:
	game_over = true
	move_timer.stop()
	reload_timer.stop()
	var remaining_enemy_array = enemy_parent.get_children().duplicate(false)
	for bullet in bullet_array:
		if is_instance_valid(bullet):
			bullet.queue_free()
	for enemy in remaining_enemy_array:
		if is_instance_valid(enemy):
			enemy.queue_free()


func _on_respawn_timer_timeout() -> void:
	_spawn_enemy(current_level)
