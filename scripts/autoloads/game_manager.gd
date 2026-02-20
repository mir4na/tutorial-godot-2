extends Node

const MAX_HEALTH := 5
const MAX_LIVES := 1

var health: int = MAX_HEALTH
var lives: int = MAX_LIVES
var score: int = 0

func _ready() -> void:
	EventBus.player_hit.connect(_on_player_hit)
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.all_enemies_defeated.connect(_on_all_enemies_defeated)

func reset_game() -> void:
	health = MAX_HEALTH
	lives = MAX_LIVES
	score = 0

func reset_for_respawn() -> void:
	health = MAX_HEALTH
	EventBus.player_health_changed.emit(health)

func _on_player_hit(damage: int) -> void:
	health = max(0, health - damage)
	EventBus.player_health_changed.emit(health)
	if health <= 0:
		_handle_death()

func _handle_death() -> void:
	lives -= 1
	EventBus.player_lives_changed.emit(lives)
	if lives <= 0:
		EventBus.game_over.emit()
	else:
		EventBus.player_died.emit()

func _on_enemy_killed(points: int) -> void:
	score += points
	EventBus.score_changed.emit(score)

func _on_all_enemies_defeated() -> void:
	EventBus.victory.emit()
