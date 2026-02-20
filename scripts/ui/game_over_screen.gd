extends Control

func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
