extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const GRAVITY = 1500.0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += GRAVITY * delta


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


	if global_position.y > 1200:
		get_tree().reload_current_scene()
