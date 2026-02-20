extends Control

@onready var next_level_button: Button = $VBoxContainer/NextLevelButton
@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)
	
	if GameManager.next_level_path != "":
		score_label.text = "I was just saying ‘BEWARE’"
	else:
		score_label.text = "FINAL SCORE: %d" % GameManager.score
	
	if GameManager.next_level_path == "":
		next_level_button.visible = false

func _on_restart_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_next_level_pressed() -> void:
	var next_lv = GameManager.next_level_path
	GameManager.next_level_path = ""
	get_tree().change_scene_to_file(next_lv)
