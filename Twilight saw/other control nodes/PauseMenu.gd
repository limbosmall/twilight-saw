extends Control

var paused = false
@onready var shop_pos = $Shop.global_position

func _input(event):
	if event.is_action_pressed("ui_cancel") and !gb.shopping:
		if paused:
			_on_resume_pressed()
		else:
			_on_texture_button_pressed()
	elif event.is_action_pressed("e") and !paused:
		if !gb.shopping:
			gb.shopping = true
		else:
			gb.shopping = false
		var tween = $Shop.create_tween()
		tween.tween_property($Shop, "position", shop_pos + int(gb.shopping) * Vector2(0, 650), 0.5 * (gb.game_speed** -1)).set_ease(Tween.EASE_IN_OUT)

func save_data():
	var game_data = {
		"score": gb.global_score,
		"big saw damage": gb.BigSaw_dmg,
		"twilight saw damage": gb.twilight_saw_dmg,
		"tiles cant spawn": gb.tiles_cant_spawn,
		"things": []
	}
	if len(get_tree().get_nodes_in_group("Savable")) != 0:
		for thing in get_tree().get_nodes_in_group("Savable"):
			if thing.destroying:
				continue
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
	if not paused and not gb.shopping:
		paused = true
		$AnimationPlayer.play("blur")
		get_tree().paused = true

func _on_resume_pressed():
	if paused:
		paused = false
		$AnimationPlayer.play_backwards("blur")
		get_tree().paused = false

func _on_save_and_quit_pressed():
	if paused:
		save_data()
		get_tree().quit()
