extends Area2D

@export var target_label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or "Player" in body.name:
		if target_label:
			target_label.visible = true
