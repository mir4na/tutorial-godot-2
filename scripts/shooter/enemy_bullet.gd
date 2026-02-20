extends Area2D

@export var speed := 300.0
var direction := Vector2.DOWN

func _ready() -> void:
	add_to_group("enemy_bullet")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	var viewport_rect = get_viewport_rect()
	if not viewport_rect.has_point(global_position + Vector2(0, 50)): # Buffer for top/bottom
		if global_position.y > viewport_rect.size.y + 100 or global_position.y < -100 or global_position.x < -100 or global_position.x > viewport_rect.size.x + 100:
			queue_free()
