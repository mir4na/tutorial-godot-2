extends Node2D

enum GamePhase { SCOUTS, ELITE, ASTEROIDS, MIXED, BOSS }

var current_game_phase: GamePhase = GamePhase.SCOUTS

var asteroid_scene: PackedScene = preload("res://scenes/shooter/asteroid.tscn")
var enemy_scenes := {
	"straight": preload("res://scenes/shooter/enemy_straight.tscn"),
	"zigzag": preload("res://scenes/shooter/enemy_zigzag.tscn"),
	"shooter": preload("res://scenes/shooter/enemy_shooter.tscn"),
	"kamikaze": preload("res://scenes/shooter/enemy_kamikaze.tscn"),
	"laser": preload("res://scenes/shooter/enemy_laser.tscn"),
	"boss": preload("res://scenes/shooter/boss_enemy.tscn")
}

var phase_duration := 20.0
var phase_timer := 0.0
var spawn_timer := 0.0
var asteroid_spawn_timer := 0.0

var enemies_alive := 0
var boss_spawned := false

func _ready() -> void:
	EventBus.enemy_killed.connect(_on_enemy_killed)
	print("Game Started: Phase 1 (Scouts)")

func _process(delta: float) -> void:
	phase_timer += delta
	
	if current_game_phase != GamePhase.BOSS and phase_timer >= phase_duration:
		_advance_phase()

	_handle_spawning(delta)

func _advance_phase() -> void:
	phase_timer = 0.0
	match current_game_phase:
		GamePhase.SCOUTS:
			current_game_phase = GamePhase.ELITE
			print("Phase 2: Elite Squadron")
		GamePhase.ELITE:
			current_game_phase = GamePhase.ASTEROIDS
			print("Phase 3: Asteroid Belt")
		GamePhase.ASTEROIDS:
			current_game_phase = GamePhase.MIXED
			print("Phase 4: Mixed Chaos")
		GamePhase.MIXED:
			current_game_phase = GamePhase.BOSS
			print("Phase 5: BOSS BATTLE")
			if EventBus.has_user_signal("boss_spawned"):
				EventBus.boss_spawned.emit()
			_spawn_boss()

func _handle_spawning(delta: float) -> void:
	spawn_timer += delta
	asteroid_spawn_timer += delta
	
	match current_game_phase:
		GamePhase.SCOUTS:
			if spawn_timer >= 1.5:
				spawn_timer = 0.0
				_spawn_enemy("straight")
		
		GamePhase.ELITE:
			if spawn_timer >= 2.0:
				spawn_timer = 0.0
				_spawn_enemy("zigzag" if randf() > 0.5 else "kamikaze")
		
		GamePhase.ASTEROIDS:
			if asteroid_spawn_timer >= 0.5:
				asteroid_spawn_timer = 0.0
				_spawn_asteroid(true)
		
		GamePhase.MIXED:
			if spawn_timer >= 2.5:
				spawn_timer = 0.0
				var r = randf()
				if r > 0.7: _spawn_enemy("laser")
				elif r > 0.4: _spawn_enemy("kamikaze")
				else: _spawn_enemy("shooter")
			if asteroid_spawn_timer >= 2.0:
				asteroid_spawn_timer = 0.0
				_spawn_asteroid(false)
		
		GamePhase.BOSS:
			pass

func _spawn_enemy(type: String) -> void:
	var enemy = enemy_scenes[type].instantiate()
	var viewport_width = get_viewport_rect().size.x
	enemy.position = Vector2(randf_range(50, viewport_width - 50), -100)
	get_tree().current_scene.add_child(enemy)
	enemies_alive += 1

func _spawn_asteroid(indestructible: bool) -> void:
	var asteroid = asteroid_scene.instantiate()
	var viewport_width = get_viewport_rect().size.x
	asteroid.position = Vector2(randf_range(30, viewport_width - 30), -100)
	asteroid.scale = Vector2.ONE * randf_range(2.0, 4.0)
	if indestructible:
		asteroid.add_to_group("indestructible")
		asteroid.modulate = Color(0.5, 0.5, 0.5)
	get_tree().current_scene.add_child(asteroid)

func _spawn_boss() -> void:
	if boss_spawned: return
	boss_spawned = true
	var boss = enemy_scenes["boss"].instantiate()
	var viewport_width = get_viewport_rect().size.x
	boss.position = Vector2(viewport_width / 2, -100)
	get_tree().current_scene.add_child(boss)

func _on_enemy_killed(_points: int) -> void:
	enemies_alive -= 1
	if current_game_phase == GamePhase.BOSS and boss_spawned and enemies_alive <= 0:
		get_tree().create_timer(2.0).timeout.connect(func(): EventBus.victory.emit())
