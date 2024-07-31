extends Node
signal BigSaw_ChangeMod(timer_speed: float, mode: String)

var global_score: int = 2000000 #Используется в twilight_saw.gd
var game_speed = 1 #Пока ненужная хуйня
var shopping = false #Используется в mouse_checker.gd и PauseMenu.gd

var has_saved_data = false #Используется в Load_btn на StartingScreen
var must_load_data = false #Используется в Load_btn на StartingScreen

var ABsaw_unlocked = false #-----\
var DrawSaw_unlocked = false #----\
var ABphline_radius = 200 #        Используется в mouse_checker.gd
var ABmax_points = 2 # -----------/
var DrawSaw_max_pixels = 500 #---/
var BigSaw_dmg = 10 #Используется в Saw.gd, PauseMenu.gd и twilight_saw.gd
var twilight_saw_damage_unlocked = false
var BigSaw_timer_unlocked = false:
	set(value):
		BigSaw_timer_unlocked = value
		emit_signal("BigSaw_ChangeMod", BigSaw_timer_speed, str(BigSaw_timer_unlocked))
var BigSaw_timer_speed = 2.0:
	set(value):
		BigSaw_timer_speed = clamp(value, 0.01, 2.0)
		emit_signal("BigSaw_ChangeMod", BigSaw_timer_speed, str(BigSaw_timer_unlocked))
var twilight_saw_dmg = 50 #Используется в twilight_saw_rot.gd, PauseMenu.gd и twilight_saw.gd

var tiles_cant_spawn = [] #Используется в twilight_saw.gd и spawn_checker.gd
var tilemap: TileMap #Лучше ничего не придумал #Используется в spawn_checker.gd

func _ready():
	if FileAccess.file_exists("user://TwilightSawSaveFile.json"):
		has_saved_data = true
