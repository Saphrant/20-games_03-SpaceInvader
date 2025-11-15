extends Node2D

signal level_complete()

@onready var enemy_parent: Node = $Enemies

@export var jelly_fish_scene : PackedScene
@export var crab_scene : PackedScene
@export var squid_scene : PackedScene

var enemies_remaining_count := 0

# How columsn and rows of each enemy type to spawn
var enemy_type_columns:= 16
var enemy_type_rows:= 2


func _ready() -> void:
	#GameManager.level_complete.connect(_spawn_enemy)
	_spawn_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _phsycis_process(delta: float) -> void:
	#logic to move the player
	pass
	
func _spawn_enemy() -> void:
	pass
	# Looping through rows
	#for y in range(num_rows):
		# Looping throuhg columns
		#for x in range(num_cols):
		#	if enemy_scene:
		#		var new_enemy = enemy_scene.instantiate()
			#	new_enemy.position = starting_pos + Vector2(x * horizontal_spacing, y * vertical_spacing)
			#	call_deferred("add_child", new_enemy)
			#	enemies_remaining_count += 1
			#	new_enemy.enemy_death.connect(_on_enemy_death)

func _on_enemy_death() -> void:
	enemies_remaining_count -= 1
	if enemies_remaining_count <= 0:
		level_complete.emit()
