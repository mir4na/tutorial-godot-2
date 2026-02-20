extends Area2D

@export var base_speed := 180.0
@export var rotation_speed := 2.0
var current_speed := 0.0

func _ready() -> void:
	add_to_group("asteroid")
	area_entered.connect(_on_area_entered)
	current_speed = base_speed * randf_range(0.8, 1.5)
	if is_in_group("indestructible"):
		pass

func _physics_process(delta: float) -> void:
	position.y += current_speed * delta
	rotation += rotation_speed * delta
	if position.y > 1180:
		queue_free()

@export var explosion_sfx: AudioStream
var explosion_scene = preload("res://scenes/shooter/explosion.tscn")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		if is_in_group("indestructible"):
			area.queue_free()
			return
		AudioManager.play_sfx(explosion_sfx)
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", explosion)
		area.queue_free()
		queue_free()
