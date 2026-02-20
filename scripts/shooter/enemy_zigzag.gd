extends EnemyBase

var time_elapsed := 0.0
var amplitude := 120.0
var frequency := 3.0
var start_x := 0.0

func _init_enemy() -> void:
	max_health = 2
	speed = 120.0
	points = 100
	health = max_health

func _ready() -> void:
	super._ready()
	start_x = position.x

func _move(delta: float) -> void:
	time_elapsed += delta
	position.y += speed * delta
	position.x = start_x + sin(time_elapsed * frequency) * amplitude
