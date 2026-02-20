extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.material = ShaderMaterial.new()
	color_rect.material.shader = preload("res://shaders/transition.gdshader")
	color_rect.material.set_shader_parameter("progress", 0.0)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_out(duration: float = 0.7) -> void:
	var tween := create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/progress", 1.0, duration)
	await tween.finished

func fade_in(duration: float = 0.7) -> void:
	color_rect.material.set_shader_parameter("progress", 1.0)
	var tween := create_tween()
	tween.tween_property(color_rect.material, "shader_parameter/progress", 0.0, duration)
	await tween.finished
