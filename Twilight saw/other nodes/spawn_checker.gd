extends Area2D

func _on_body_entered(_body):
	gb.tiles_cant_spawn.append(gb.tilemap.local_to_map(self.global_position))

func _on_body_exited(_body):
	gb.tiles_cant_spawn.erase(gb.tilemap.local_to_map(self.global_position))
