extends Control

@onready var next_level_button: Button = $VBoxContainer/NextLevelButton
@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)
	
	score_label.text = "I was just saying ‘beware.’"
	
	if GameManager.next_level_path == "":
		next_level_button.visible = false

func _on_restart_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_next_level_pressed() -> void:
	var next_lv = GameManager.next_level_path
	GameManager.next_level_path = ""
	get_tree().change_scene_to_file(next_lv)
