extends PathFollow2D

func _process(delta):
	progress_ratio += delta * gb.game_speed
	if progress_ratio == 1:
		get_parent().queue_free()
