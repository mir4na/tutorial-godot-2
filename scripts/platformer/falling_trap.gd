extends Area2D

@export var target_obstacle: Node2D
@export var fall_speed := 2000.0
@export var target_y := 10000.0

var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if triggered and target_obstacle:
		if target_obstacle.position.y < target_y:
			target_obstacle.position.y += fall_speed * delta
		else:
			target_obstacle.position.y = target_y
			set_physics_process(false)

func _on_body_entered(body: Node2D) -> void:
	if triggered: return
	if body.is_in_group("player") or "PlatformerPlayer" in body.name:
		print("test")
		triggered = true
