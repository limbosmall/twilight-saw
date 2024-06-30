extends Area2D

var trash = []
var saws = []
var logs = []
var cusor_pick

class CursorLog:
	extends Sprite2D
	
	func _init(original_body: CharacterBody2D):
		self.texture = original_body.localsprite.texture
		self.modulate.a = 0.5
		var script = load("res://other nodes/CursorLog.gd")
		set_script(script)
		set("log_group", original_body.get_groups()[1])
		set("original_log", original_body)

func _process(_delta):
	self.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if len(logs) != 0:
					cusor_pick = CursorLog.new(logs[0])
					cusor_pick.z_index = 1
					add_child(cusor_pick)
			else:
				if is_instance_valid(cusor_pick):
					if cusor_pick.can_stack:
						cusor_pick.original_log.queue_free()
						cusor_pick.multiply_to_log.multiplier += cusor_pick.original_log.multiplier
						cusor_pick.queue_free()
						cusor_pick = null
					else:
						cusor_pick.queue_free()
						cusor_pick = null
				elif len(trash) != 0:
					for body in trash:
						if not body.destroying:
							body.Destroy()
				elif len(saws) != 0:
					for body in saws:
						body.Clicked()

func _on_body_entered(body):
	if body.is_in_group("Trash"):
		trash.append(body)
	elif body.is_in_group("Log"):
		logs.append(body)

func _on_body_exited(body):
	if body.is_in_group("Trash"):
		trash.erase(body)
	elif body.is_in_group("Log"):
		logs.erase(body)

func _on_area_entered(area):
	if area.is_in_group("Saw"):
		saws.append(area)


func _on_area_exited(area):
	if area.is_in_group("Saw"):
		saws.erase(area)
