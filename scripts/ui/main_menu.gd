extends Control

@export var menu_bgm: AudioStream

func _ready() -> void:
	AudioManager.play_bgm(menu_bgm)
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/platformer/level_1.tscn")
