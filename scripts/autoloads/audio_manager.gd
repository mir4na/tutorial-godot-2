extends Node

var bgm_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	
	for i in 10:
		var p = AudioStreamPlayer.new()
		add_child(p)
		sfx_players.append(p)

var active_bgm_tween: Tween

func play_bgm(stream: AudioStream, volume_db: float = -10.0) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	if active_bgm_tween:
		active_bgm_tween.kill()
	bgm_player.stop()
	bgm_player.stream = stream
	bgm_player.volume_db = volume_db
	bgm_player.play()

func stop_bgm() -> void:
	if active_bgm_tween:
		active_bgm_tween.kill()
	bgm_player.stop()

func fade_out_bgm(duration: float = 2.0) -> void:
	if active_bgm_tween:
		active_bgm_tween.kill()
	active_bgm_tween = create_tween()
	active_bgm_tween.tween_property(bgm_player, "volume_db", -80.0, duration)
	await active_bgm_tween.finished
	bgm_player.stop()
	bgm_player.volume_db = -10.0

func play_sfx(stream: AudioStream, volume_db: float = -5.0, pitch_scale: float = 1.0) -> void:
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.pitch_scale = pitch_scale
			p.play()
			return
