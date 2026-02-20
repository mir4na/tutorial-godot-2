extends EnemyBase

var shoot_cooldown := 2.0
var shoot_timer := 0.0
var enemy_bullet_scene: PackedScene = preload("res://scenes/shooter/enemy_bullet.tscn")

func _init_enemy() -> void:
	max_health = 3
	speed = 80.0
	points = 150
	health = max_health

func _attack(delta: float) -> void:
	shoot_timer += delta
	if shoot_timer >= shoot_cooldown:
		shoot_timer = 0.0
		_fire()

func _fire() -> void:
	var bullet := enemy_bullet_scene.instantiate()
	bullet.global_position = global_position + Vector2(0, 20)
	get_tree().current_scene.add_child(bullet)
