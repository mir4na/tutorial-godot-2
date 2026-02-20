extends EnemyBase

var bullet_scene = preload("res://scenes/shooter/enemy_bullet.tscn")

var attack_timer := 0.0
var pattern_index := 0
var angle_offset := 0.0

func _init_enemy() -> void:
	max_health = 100
	speed = 50.0
	points = 5000
	health = max_health

func _ready() -> void:
	super._ready()
	EventBus.boss_health_changed.emit(health, max_health)

func _move(delta: float) -> void:
	if position.y < 150:
		position.y += speed * delta
	else:
		position.x += sin(Time.get_ticks_msec() * 0.001) * 200.0 * delta

func _attack(delta: float) -> void:
	attack_timer += delta
	
	match pattern_index:
		0:
			if attack_timer >= 0.1:
				attack_timer = 0.0
				_fire_circle(12, angle_offset)
				angle_offset += 0.2
			if Time.get_ticks_msec() % 5000 < 50:
				pattern_index = 1
		
		1:
			if attack_timer >= 0.05:
				attack_timer = 0.0
				_fire_spiral()
			if Time.get_ticks_msec() % 5000 < 50:
				pattern_index = 2
				
		2:
			if attack_timer >= 0.5:
				attack_timer = 0.0
				_fire_fan()
			if Time.get_ticks_msec() % 5000 < 50:
				pattern_index = 0

func _fire_circle(count: int, offset: float) -> void:
	for i in range(count):
		var angle = (PI * 2 / count) * i + offset
		_spawn_bullet(angle)

func _fire_spiral() -> void:
	angle_offset += 0.15
	_spawn_bullet(angle_offset)

func _fire_fan() -> void:
	for i in range(-3, 4):
		var angle = PI/2 + (i * 0.2)
		_spawn_bullet(angle)

func _spawn_bullet(angle: float) -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = Vector2(cos(angle), sin(angle))
	get_tree().current_scene.add_child(bullet)

func take_damage(amount: int) -> void:
	super.take_damage(amount)
	EventBus.boss_health_changed.emit(health, max_health)
