extends Control

var paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if paused:
			_on_resume_pressed()
		else:
			_on_texture_button_pressed()

func quiter(mode: String):
	save_data()
	if mode == "MainMenu":
		get_tree().change_scene_to_file("res://working area/StartingScreen.tscn")
	else:
		get_tree().quit()

func save_data():
	var game_data = {
		"score": gb.global_score,
		"saw level": gb.saw_lvl,
		"tiles cant spawn": gb.tiles_cant_spawn,
		"things": []
	}
	if len(get_tree().get_nodes_in_group("Savable")) != 0:
		for thing in get_tree().get_nodes_in_group("Savable"):
			game_data["things"].append({
				"sprite_texture": thing.localsprite.texture.resource_path,
				"collision_size": thing.collision_size,
				"saving_group": thing.get_groups()[2],
				"group": thing.get_groups()[0],
				"stack_group": thing.get_groups()[1],
				"hp": thing.local_hp,
				"scoreadd": thing.scoreadd,
				"max_stack": thing.max_stack,
				"pos": thing.global_position
			})
	var file = FileAccess.open("user://TwilightSawSaveFile.json", FileAccess.WRITE)
	file.store_var(game_data)
	file = null

func _on_texture_button_pressed():
	if not paused:
		paused = true
		$AnimationPlayer.play("blur")
		get_tree().paused = true

func _on_resume_pressed():
	if paused:
		paused = false
		$AnimationPlayer.play_backwards("blur")
		get_tree().paused = false

func _on_main_menu_pressed():
	quiter("MainMenu")

func _on_save_and_quit_pressed():
	quiter("Save and quit")
