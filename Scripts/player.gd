extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var explosion: AnimatedSprite2D = $explosion
@onready var laser_sound: AudioStreamPlayer = $LaserSound
@onready var reload_timer: Timer = $ReloadTimer
@onready var respawn_timer: Timer = $RespawnTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var bullet_scene : PackedScene
@export var player_speed := 120.0

var screen_size: Vector2

var min_x := 48.0
var max_x := 577.0

var direction_x := 0.0
var current_health := 3
var bullet_exist : bool
var is_player_dead : bool
var is_game_over: bool

func _ready() -> void:
	is_game_over = false
	screen_size = get_viewport_rect().size
	animated_sprite_2d.show()
	explosion.hide()
	GameManager.game_over.connect(_on_game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_game_over:
		return
	direction_x = Input.get_axis("left","right")
	
	var new_x = position.x + direction_x * player_speed * delta
	if !is_player_dead:
		position.x = clampf(new_x, min_x, max_x)
		if Input.is_action_just_pressed("shoot") and !bullet_exist:
			animated_sprite_2d.play("default")
			_shoot()

func _shoot() -> void:
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.global_position = marker_2d.global_position
	get_parent().add_child(bullet)
	laser_sound.play()
	bullet_exist = true
	reload_timer.start()
	

func _on_hit() -> void:
	is_player_dead = true
	GameManager.on_life_lost()
	animated_sprite_2d.hide()
	collision_shape_2d.set_deferred("disabled", true)
	explosion.show()
	explosion.play("default")
	await explosion.animation_finished
	explosion.hide()
	respawn_timer.start()

		
	
func _on_area_entered(_area: Area2D) -> void:
	if !is_player_dead:
		_on_hit()


func _on_reload_timer_timeout() -> void:
	bullet_exist = false


func _on_respawn_timer_timeout() -> void:
	if is_game_over:
		return
	animated_sprite_2d.show()
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(screen_size.x/2,360),0.4).from(Vector2(0,360))
	collision_shape_2d.set_deferred("disabled", false)
	is_player_dead = false

func _on_game_over() -> void:
	is_game_over = true
