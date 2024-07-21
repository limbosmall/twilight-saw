extends Area2D

var points = []
var next_point
var direction
var current_index = 0
var speed = 200 * gb.game_speed

func _ready():
	global_position = points[0]
	current_index = 1
	next_point = points[1]
	direction = (next_point - global_position).normalized()

func _process(delta):
	$Sprite2D.rotation += 0.5

	if (global_position - next_point).length() < 0.1:
		current_index = (current_index + 1) % points.size()
		next_point = points[current_index]
		direction = (next_point - global_position).normalized()
	global_position += direction * delta * speed
	if (global_position - points[-1]).length() < 0.1:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Log") or body.is_in_group("Trash"):
		body.Sawed(gb.twilight_saw_dmg)
