extends CharacterBody2D

const SPEED := 450.0
const SHOOT_COOLDOWN := 0.15

var can_shoot := true
var bullet_scene: PackedScene = preload("res://scenes/shooter/bullet.tscn")

@export var shoot_sfx: AudioStream
@export var hit_sfx: AudioStream
@export var death_sfx: AudioStream

@onready var shoot_timer: Timer = $ShootTimer
@onready var hitbox: Area2D = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D

var hit_flash_shader = preload("res://shaders/hit_flash.gdshader")

var is_invincible := false

func _ready() -> void:
	add_to_group("player")
	shoot_timer.wait_time = SHOOT_COOLDOWN
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	EventBus.player_died.connect(_on_player_died)
	
	var mat = ShaderMaterial.new()
	mat.shader = hit_flash_shader
	sprite.material = mat

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	velocity = direction * SPEED
	move_and_slide()
	_clamp_position()

	if Input.is_action_pressed("shoot") and can_shoot:
		_shoot()

func _clamp_position() -> void:
	var viewport_rect := get_viewport_rect()
	position.x = clamp(position.x, 20, viewport_rect.size.x - 20)
	position.y = clamp(position.y, 20, viewport_rect.size.y - 20)

func _shoot() -> void:
	can_shoot = false
	shoot_timer.start()
	AudioManager.play_sfx(shoot_sfx)
	var bullet := bullet_scene.instantiate()
	bullet.global_position = global_position + Vector2(0, -30)
	get_tree().current_scene.add_child(bullet)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if is_invincible: return
	
	if area.is_in_group("enemy_hazard") or area.is_in_group("asteroid"):
		_take_hit()
	if area.is_in_group("enemy_bullet"):
		_take_hit()
		area.queue_free()

func _take_hit() -> void:
	is_invincible = true
	EventBus.player_hit.emit(1)
	AudioManager.play_sfx(hit_sfx)
	_flash_effect()
	_start_invincibility_cooldown()

func _start_invincibility_cooldown() -> void:
	var blink_count = 10
	for i in range(blink_count):
		sprite.modulate.a = 0.5
		await get_tree().create_timer(0.1).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout
	is_invincible = false

func _on_player_died() -> void:
	AudioManager.play_sfx(death_sfx)

func _flash_effect() -> void:
	sprite.material.set_shader_parameter("flash_color", Color.RED)
	sprite.material.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	sprite.material.set_shader_parameter("active", false)
