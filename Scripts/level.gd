extends Node2D

signal level_complete()

@onready var enemy_parent: Node = $Enemies

@export var jelly_fish_scene : PackedScene
@export var crab_scene : PackedScene
@export var squid_scene : PackedScene

var enemies_remaining_count := 0

# How columsn and rows of each enemy type to spawn
var enemy_size = Vector2(16,16)
var enemy_type_columns:= 11
var enemy_type_rows:= 2

# Spawning logic
var col_padding:= 8
var row_padding:= 8
var screen_size
var screen_middle
var screen_padding:= 55
var left_column: Array
var right_column: Array

var move_direction:= 1

func _ready() -> void:
	screen_size = get_viewport_rect().size
	screen_middle = screen_size / 2
	#GameManager.level_complete.connect(_spawn_enemy)
	_spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _phsycis_process(_delta: float) -> void:
	#logic to move the player
	pass
	
func _spawn_enemy() -> void:
	var enemy_type := [
	squid_scene,
	crab_scene,
	jelly_fish_scene
	]
	var starting_pos_x = (screen_middle.x + enemy_size.x/2) - ((enemy_size.x * enemy_type_columns) + (col_padding * (enemy_type_columns - 1))) / 2 #Finds the group X middle
	var starting_pos_y = screen_middle.y - (((enemy_size.y + row_padding) * enemy_type_rows) * 3) / 2 #Finds the group Y middle
	var starting_pos = Vector2(starting_pos_x, (starting_pos_y - 50))
	#Looping through rows
	for y in range(enemy_type_rows * 3):
		# Looping throuhg columns
		for x in range(enemy_type_columns):
			@warning_ignore("integer_division")
			var	enemy_to_spawn = enemy_type[(y / enemy_type_rows)]
			var enemy = enemy_to_spawn.instantiate()
			if x == 0:
				left_column.append(enemy)
			elif x == 10:
				right_column.append(enemy)
			enemy.position = Vector2(x * (enemy_size.x + col_padding), y * (enemy_size.y + row_padding))
			enemy_parent.call_deferred("add_child", enemy)
			enemies_remaining_count += 1
			enemy.enemy_death.connect(_on_enemy_death)
	enemy_parent.global_position = starting_pos
			

func _on_enemy_death(enemy_instance) -> void:
	left_column.erase(enemy_instance)
	right_column.erase(enemy_instance)
	enemies_remaining_count -= 1
	if enemies_remaining_count <= 0:
		level_complete.emit()

func _on_move_timer_timeout() -> void:
	var remaining_enemy_array = enemy_parent.get_children()
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
			
		
