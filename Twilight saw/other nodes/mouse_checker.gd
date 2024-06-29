extends Area2D

var trash = []
var saws = []

func _process(_delta):
	self.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if len(trash) != 0:
				for body in trash:
					if not body.destroying:
						body.Destroy()
			elif len(saws) != 0:
				for body in saws:
					body.Clicked()

func _on_body_entered(body):
	if body.is_in_group("Trash"):
		trash.append(body)

func _on_body_exited(body):
	if body.is_in_group("Trash"):
		trash.erase(body)

func _on_area_entered(area):
	if area.is_in_group("Saw"):
		saws.append(area)


func _on_area_exited(area):
	if area.is_in_group("Saw"):
		saws.erase(area)
