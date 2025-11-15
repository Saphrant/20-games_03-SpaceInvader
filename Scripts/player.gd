extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D

@export var bullet_scene : PackedScene
@export var player_speed := 100.0

var min_x := 48.0
var max_x := 577.0

var direction_x := 0.0
var current_health := 3
var bullet_exist : bool

func _ready() -> void:
	GameManager.bullet_exist.connect(_on_bullet_exist)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction_x = Input.get_axis("left","right")
	
	var new_x = position.x + direction_x * player_speed * delta
	position.x = clampf(new_x, min_x, max_x)
	
	if Input.is_action_just_pressed("shoot") and !bullet_exist:
		animated_sprite_2d.play("default")
		_shoot()
		bullet_exist = true 

func _shoot() -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.global_position = marker_2d.global_position
	get_parent().add_child(bullet)

func _on_hit() -> void:
	GameManager.on_life_lost()
	queue_free()
	
func _on_bullet_exist(bullet_destroyed) -> void:
	bullet_exist = bullet_destroyed
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_projectile"):
		_on_hit()
