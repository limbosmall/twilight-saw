class_name Saw
extends Area2D

var things = []

func _on_body_entered(body):
	if body.is_in_group("Log") or body.is_in_group("Trash"):
		things.append(body)

func _on_body_exited(body):
	if body.is_in_group("Log") or body.is_in_group("Trash"):
		things.erase(body)

func Clicked():
	$AnimatedSprite2D.play("default")
	for thing in things:
		thing.Sawed()
