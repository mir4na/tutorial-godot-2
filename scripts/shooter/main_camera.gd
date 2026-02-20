extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 5.0
var initial_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	initial_offset = offset
	EventBus.player_hit.connect(_on_player_hit)

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
		offset = initial_offset + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

func _on_player_hit(_damage: int) -> void:
	shake_strength = 20.0
