extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const GRAVITY = 1500.0

@export var jump_sfx: AudioStream

@onready var sprite: Sprite2D = $Sprite2D

var hit_flash_shader = preload("res://shaders/hit_flash.gdshader")

func _ready() -> void:
	EventBus.player_died.connect(_flash_effect)
	var mat = ShaderMaterial.new()
	mat.shader = hit_flash_shader
	sprite.material = mat

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += GRAVITY * delta


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AudioManager.play_sfx(jump_sfx)


	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


	if global_position.y > 1200:
		get_tree().reload_current_scene()

func _flash_effect() -> void:
	if sprite and sprite.material:
		sprite.material.set_shader_parameter("flash_color", Color.RED)
		sprite.material.set_shader_parameter("active", true)
		await get_tree().create_timer(0.1).timeout
		sprite.material.set_shader_parameter("active", false)
