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
var col_padding:= 16
var row_padding:= 16
var screen_size
var screen_middle
var screen_padding:= 25
var starting_pos : Vector2

var move_direction:= 1
var hit_wall:= false

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
	jelly_fish_scene,
	crab_scene,
	squid_scene
	]
	var starting_pos_x = (screen_middle.x + enemy_size.x) - ((enemy_size.x * enemy_type_columns) + (col_padding * (enemy_type_columns - 1))) / 2 #Finds the group X middle
	var starting_pos_y = screen_middle.y - (((enemy_size.y + row_padding) * enemy_type_rows) * 3) / 2 #Finds the group Y middle
	var starting_pos = Vector2(starting_pos_x, starting_pos_y)
	#Looping through rows
	for y in range((enemy_type_rows * 3)-1):
		# Looping throuhg columns
		for x in range(enemy_type_columns):
			var	enemy_to_spawn = enemy_type[(y / enemy_type_rows)]
			var enemy = enemy_to_spawn.instantiate()
			enemy.position = Vector2(x * (enemy_size.x + col_padding), y * (enemy_size.y + row_padding))
			enemy_parent.call_deferred("add_child", enemy)
			enemies_remaining_count += 1
			enemy.enemy_death.connect(_on_enemy_death)
	enemy_parent.global_position = starting_pos
	print(enemy_parent.global_position)

func _on_enemy_death() -> void:
	enemies_remaining_count -= 1
	if enemies_remaining_count <= 0:
		level_complete.emit()

func _move_group_x() -> void:
	var enemy_group_size = (enemy_size.x * enemy_type_columns) + (col_padding * (enemy_type_columns - 1))
	var visual_left_edge = enemy_parent.global_position.x - (enemy_size.x /2)
	var visual_right_edge = visual_left_edge + enemy_group_size
	var max_x = screen_size.x - screen_padding
	if visual_left_edge <= screen_padding or visual_right_edge > max_x:
		hit_wall = true
	enemy_parent.global_position.x += move_direction * enemy_size.x
	print(visual_right_edge, " ", max_x)


func _on_move_timer_timeout() -> void:
	if hit_wall:
		_move_group_x()
		
