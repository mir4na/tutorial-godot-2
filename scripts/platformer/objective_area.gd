extends Area2D

@export_file("*.tscn") var next_level: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or "Player" in body.name:
		GameManager.next_level_path = next_level
		EventBus.victory.emit()
