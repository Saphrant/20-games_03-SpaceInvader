extends CharacterBody2D

@onready var bullet_parent: Node2D = $"../bullet_parent"

const TILE_SIZE:= Vector2(16,16)


@export var bullet_scene: PackedScene

var sprite_node_pos_tween: Tween
var bullet_speed := 400

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and is_instance_valid(bullet_scene):
		_shoot() 
	if !sprite_node_pos_tween or !sprite_node_pos_tween.is_running():
		if Input.is_action_pressed("left") and !$left.is_colliding():
			_move(Vector2.LEFT)
		if Input.is_action_pressed("right") and !$right.is_colliding():
			_move(Vector2.RIGHT)
func _move(dir: Vector2) -> void:
	global_position += dir * TILE_SIZE
	$Sprite2D.global_position -= dir * TILE_SIZE
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)

func _shoot() -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.global_position.x = (global_position.x / 16) - 1
	add_child(bullet)
	print(global_position, bullet.global_position)
