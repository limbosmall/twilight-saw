extends Node

var global_score: int = 0
var game_speed = 1
var saw_lvl = 1
var tiles_cant_spawn = []

var tilemap: TileMap #Лучше ничего не придумал
#var base_speed = 1.0
#var acceleration_factor = 0.05
#var score_threshold = 10000.0
#var score_exponent = 0.5
#var score_ratio = max(0, (global_score - score_threshold) / score_threshold)
#var speed_increase = acceleration_factor * pow(score_ratio, score_exponent)
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
