extends EnemyBase

var bullet_scene = preload("res://scenes/shooter/enemy_bullet.tscn")
@export var laser_sfx: AudioStream
var attack_timer := 0.0
var attack_cooldown := 3.0

func _init_enemy() -> void:
	max_health = 4
	speed = 60.0
	points = 1000
	health = max_health

func _attack(delta: float) -> void:
	attack_timer += delta
	if attack_timer >= attack_cooldown:
		attack_timer = 0.0
		AudioManager.play_sfx(laser_sfx)
		_fire_laser()

func _fire_laser() -> void:
	var player = get_tree().get_nodes_in_group("player")[0] if get_tree().has_group("player") else null
	var direction = Vector2.DOWN
	if player and is_instance_valid(player):
		direction = (player.global_position - global_position).normalized()
	
	var laser = bullet_scene.instantiate()
	laser.global_position = global_position + Vector2(0, 40)
	laser.direction = direction
	laser.rotation = direction.angle() + PI/2
	laser.speed = 1200.0
	laser.scale = Vector2(0.5, 4.0)
	laser.modulate = Color(1.0, 0.2, 1.0, 1.0)
	get_tree().current_scene.add_child(laser)
