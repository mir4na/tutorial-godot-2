extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var lives_label: Label = $LivesLabel
@onready var score_label: Label = $ScoreLabel

@onready var boss_health_bar: ProgressBar = $BossContainer/BossHealthBar
@onready var mission_label: Label = $MissionLabel

func _ready() -> void:
	EventBus.player_health_changed.connect(_on_health_changed)
	EventBus.score_changed.connect(_on_score_changed)
	EventBus.boss_health_changed.connect(_on_boss_health_changed)
	$BossContainer.hide()
	_update_all()

func hide_mission_label() -> void:
	var tween = create_tween()
	tween.tween_property(mission_label, "modulate:a", 0.0, 1.0)
	await tween.finished
	mission_label.hide()

func _update_all() -> void:
	_on_health_changed(GameManager.health)
	_on_score_changed(GameManager.score)

func _on_health_changed(new_health: int) -> void:
	health_label.text = "HP: %d/%d" % [new_health, GameManager.MAX_HEALTH]

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: %d" % new_score

func _on_boss_health_changed(current: int, max_val: int) -> void:
	if not $BossContainer.visible:
		$BossContainer.show()
	boss_health_bar.max_value = max_val
	boss_health_bar.value = current
	if current <= 0:
		$BossContainer.hide()
