extends Node

@onready var transition: CanvasLayer = $TransitionEffect
var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")

@export var level_bgm: AudioStream
@export var victory_bgm: AudioStream
@export var game_over_bgm: AudioStream
#@export var boss_bgm: AudioStream

func _ready() -> void:
	EventBus.player_died.connect(_on_player_died)
	EventBus.game_over.connect(_on_game_over)
	EventBus.victory.connect(_on_victory)
	#EventBus.boss_spawned.connect(_on_boss_spawned)

	transition.fade_in()
	
	if level_bgm:
		AudioManager.play_bgm(level_bgm)
	
	var pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)


func _on_player_died() -> void:
	await transition.fade_out(0.3)
	GameManager.reset_for_respawn()
	get_tree().reload_current_scene()

func _on_game_over() -> void:
	AudioManager.play_bgm(game_over_bgm)
	await transition.fade_out()
	get_tree().change_scene_to_file("res://scenes/ui/game_over_screen.tscn")

func _on_victory() -> void:
	AudioManager.play_bgm(victory_bgm)
	await transition.fade_out()
	get_tree().change_scene_to_file("res://scenes/ui/victory_screen.tscn")

#func _on_boss_spawned() -> void:
	#AudioManager.play_bgm(boss_bgm)
