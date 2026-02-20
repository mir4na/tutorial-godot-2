extends CanvasLayer

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_resume()
		else:
			_pause()

func _resume() -> void:
	get_tree().paused = false
	hide()

func _pause() -> void:
	get_tree().paused = true
	show()

func _on_resume_button_pressed() -> void:
	_resume()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
