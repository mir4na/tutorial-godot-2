extends Node

signal player_hit(damage: int)
signal player_died
signal player_health_changed(new_health: int)
signal player_lives_changed(new_lives: int)
signal enemy_killed(points: int)
signal score_changed(new_score: int)
signal all_enemies_defeated
signal boss_health_changed(current: int, max_val: int)
signal boss_transition_started
signal boss_defeated
signal boss_spawned
signal game_over
signal victory
