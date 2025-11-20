extends Control

@onready var highscore_menu_label: Label = $MarginContainer/VBoxContainer2/VBoxContainer/HighscoreMenuLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var highscore = GameData.high_score
	highscore_menu_label.text = "Highscore: %s" % highscore


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	elif Input.is_action_just_pressed("esc"):
		get_tree().quit()
