extends Area2D

const SPEED := 800.0

func _ready() -> void:
	add_to_group("player_bullet")
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.y < -50:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("asteroid"):
		queue_free()
