extends Area2D

func _process(delta):
	$Sprite2D.rotation += 0.5

func _on_body_entered(body):
	if body.is_in_group("Log") or body.is_in_group("Trash"):
		body.Sawed(gb.twilight_saw_dmg)
