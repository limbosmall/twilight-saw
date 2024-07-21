extends Node

var global_score: int = 0 #Используется в twilight_saw.gd
var game_speed = 1 #Пока ненужная хуйня

var has_saved_data = false #Используется в Load_btn на StartingScreen
var must_load_data = false #Используется в Load_btn на StartingScreen

var ABphline_radius = 200
var ABmax_points = 5
var big_saw_dmg = 10 #Пока ненужная хуйня
var twilight_saw_dmg = 50

var tiles_cant_spawn = [] #Используется в twilight_saw.gd и spawn_checker.gd
var tilemap: TileMap #Лучше ничего не придумал #Используется в spawn_checker.gd

func _ready():
	if FileAccess.file_exists("user://TwilightSawSaveFile.json"):
		has_saved_data = true
