extends EnemyBase

var target_player: Node2D = null
var has_passed_player := false

func _init_enemy() -> void:
	max_health = 2
	speed = 500.0
	points = 500
	health = max_health

func _ready() -> void:
	super._ready()
	area_entered.connect(_on_kamikaze_area_entered)
	target_player = get_tree().get_nodes_in_group("player")[0] if get_tree().has_group("player") else null

func _on_kamikaze_area_entered(area: Area2D) -> void:
	if area.get_parent() is CharacterBody2D and area.get_parent().is_in_group("player"):
		_die()

func _move(delta: float) -> void:
	if target_player and is_instance_valid(target_player) and not has_passed_player:
		if global_position.y >= target_player.global_position.y:
			has_passed_player = true
		else:
			var direction = (target_player.global_position - global_position).normalized()
			global_position += direction * speed * delta
			rotation = direction.angle() + PI/2
			return

	position.y += speed * delta
