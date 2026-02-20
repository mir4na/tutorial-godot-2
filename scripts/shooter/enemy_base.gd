extends Area2D
class_name EnemyBase

@export var max_health := 2
@export var speed := 150.0
@export var points := 100

var health: int

@export var explosion_sfx: AudioStream

@onready var sprite: Sprite2D = $Sprite2D

var hit_flash_shader = preload("res://shaders/hit_flash.gdshader")

func _ready() -> void:
	scale = Vector2(2.0, 2.0)
	health = max_health
	add_to_group("enemy")
	add_to_group("enemy_hazard")
	area_entered.connect(_on_area_entered)
	
	if sprite:
		var mat = ShaderMaterial.new()
		mat.shader = hit_flash_shader
		sprite.material = mat
	
	_init_enemy()

func _init_enemy() -> void:
	pass

func _physics_process(delta: float) -> void:
	_move(delta)
	_attack(delta)
	
	var viewport_rect = get_viewport_rect()
	if global_position.y > viewport_rect.size.y + 100:
		queue_free()

func _move(delta: float) -> void:
	position.y += speed * delta

func _attack(_delta: float) -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
	_flash_effect()
	if health <= 0:
		_die()

var explosion_scene = preload("res://scenes/shooter/explosion.tscn")

func _die() -> void:
	EventBus.enemy_killed.emit(points)
	AudioManager.play_sfx(explosion_sfx)
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", explosion)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		take_damage(1)

func _flash_effect() -> void:
	if sprite and sprite.material:
		sprite.material.set_shader_parameter("active", true)
		await get_tree().create_timer(0.05).timeout
		if sprite and sprite.material:
			sprite.material.set_shader_parameter("active", false)
