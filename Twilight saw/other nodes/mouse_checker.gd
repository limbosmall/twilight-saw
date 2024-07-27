extends Area2D

var trash = []
var saws = []
var logs = []
var ABpointing = false
var Drawing = false
var can_drawing = false
var canseled = false
var pointcount = 1
var pixels_left = 2000
var last_position: Vector2
var line: Line2D
var cusor_pick
var phline

const point = preload("res://other nodes/point.tscn")

class CursorLog:
	extends Sprite2D
	
	func _init(original_body: CharacterBody2D):
		self.texture = original_body.localsprite.texture
		self.modulate.a = 0.5
		var script = load("res://other nodes/CursorLog.gd")
		set_script(script)
		set("log_group", original_body.get_groups()[1])
		set("original_log", original_body)

class PhantomLine:
	extends Line2D
	
	var stpt
	var endpt
	var pts = []
	var connectline = Line2D.new()
	var done = false
	
	func _init(StartingPoint: Vector2):
		stpt = StartingPoint
	
	func _ready():
		get_parent().add_child(connectline)
		connectline.default_color = Color(1, 1, 1, 0.7)
		connectline.width = 8
		connectline.add_point(stpt)
		self.default_color = Color(1, 1, 1, 0.5)
		self.width = 4
		CreatePoint(stpt)
	
	func _process(_delta):
		endpt = get_global_mouse_position()
		var direction = (endpt - stpt).normalized()
		if stpt.distance_to(endpt) > gb.ABphline_radius:
			endpt = stpt + direction * gb.ABphline_radius
		self.points = [stpt, endpt]
	
	func _input(event):
		if event.is_action_pressed("ui_accept"):
			done = true
			Clicked()
	
	func Clicked():
		CreatePoint(endpt)
		connectline.add_point(endpt)
		stpt = endpt
		if get_parent().get_node("MouseChecker").pointcount > gb.ABmax_points or done:
			#Код для спавна пилы, идущей по пути с точками connectline, и уничтожения точек с connectline, но мне лень писать его :Р
			var saw_scene = preload("res://other nodes/twilight_saw_rot.tscn").instantiate()
			var path = Path2D.new()
			var pfollow = PathFollow2D.new()
			pfollow.loop = false
			pfollow.set_script(preload("res://other nodes/TwilightSaw_PathFollow.gd"))
			pfollow.add_child(saw_scene)
			var curve = Curve2D.new()
			for point in connectline.points:
				curve.add_point(point)
			path.set_curve(curve)
			path.add_child(pfollow)
			for child in pts:
				child.queue_free()
			connectline.queue_free()
			get_parent().add_child(path)
			get_parent().get_node("MouseChecker").phline = null
			get_parent().get_node("MouseChecker").pointcount = 1
			get_parent().get_node("MouseChecker").ABpointing = false
			queue_free()
	
	func CreatePoint(pos):
		var instapoint = get_parent().get_node("MouseChecker").point.instantiate()
		pts.append(instapoint)
		get_parent().add_child(instapoint)
		instapoint.global_position = pos
		instapoint.get_node("Label").text = str(get_parent().get_node("MouseChecker").pointcount)
		get_parent().get_node("MouseChecker").pointcount += 1

func _process(_delta):
	var current_pos = get_global_mouse_position()
	self.global_position = current_pos
	if can_drawing and current_pos.distance_to(last_position) >= 10:
		line = Line2D.new()
		line.default_color = Color(1,1,1,0.5)
		line.width = 8
		get_parent().add_child(line)
		line.add_point(last_position)
		can_drawing = false
		Drawing = true
	if Drawing:
		if current_pos != last_position:
			var distance = current_pos.distance_to(last_position)
			pixels_left -= distance
			if pixels_left <= 0:
				DrawPathSaw()
			else:
				line.add_point(current_pos)
				last_position = current_pos

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if !Drawing and len(logs) == 0 and len(saws) == 0 and len(trash) == 0 and !is_instance_valid(cusor_pick) and !ABpointing:
					can_drawing = true
					last_position = event.position
				if len(logs) != 0 and !ABpointing and !Drawing:
					cusor_pick = CursorLog.new(logs[0])
					cusor_pick.z_index = 1
					add_child(cusor_pick)
			else:
				if can_drawing and get_global_mouse_position().distance_to(last_position) <= 10:
					can_drawing = false
				if !Drawing and len(logs) == 0 and len(saws) == 0 and len(trash) == 0 and !is_instance_valid(cusor_pick) and !ABpointing and !canseled:
					ABpointing = true
				if Drawing:
					DrawPathSaw()
				if ABpointing and !canseled:
					ABPointer()
				elif is_instance_valid(cusor_pick):
					if cusor_pick.can_stack:
						cusor_pick.original_log.queue_free()
						cusor_pick.multiply_to_log.multiplier += cusor_pick.original_log.multiplier
						cusor_pick.queue_free()
						cusor_pick = null
					else:
						cusor_pick.queue_free()
						cusor_pick = null
				elif len(trash) != 0 and !Drawing and !ABpointing:
					for body in trash:
						if not body.destroying:
							body.Destroy()
				elif len(saws) != 0 and !Drawing and !ABpointing:
					for body in saws:
						body.Clicked()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				if Drawing:
					line.queue_free()
					Drawing = false
					can_drawing = false
					pixels_left = 2000
					canseled = true
					await get_tree().create_timer(0.5).timeout
					canseled = false
				if ABpointing:
					for pt in phline.pts:
						pt.queue_free()
					phline.connectline.queue_free()
					phline.queue_free()
					phline = null
					pointcount = 1
					ABpointing = false

func DrawPathSaw():
	Drawing = false
	pixels_left = 2000
	var saw_scene = preload("res://other nodes/twilight_saw_rot.tscn").instantiate()
	var curve = Curve2D.new()
	for pt in line.points:
		curve.add_point(pt)
	var path = Path2D.new()
	path.set_curve(curve)
	var pfollow = PathFollow2D.new()
	pfollow.loop = false
	pfollow.set_script(preload("res://other nodes/TwilightSaw_PathFollow.gd"))
	pfollow.add_child(saw_scene)
	path.add_child(pfollow)
	get_parent().add_child(path)
	line.queue_free()
	canseled = true
	await get_tree().create_timer(0.5).timeout
	canseled = false

func ABPointer():
	if is_instance_valid(phline):
		phline.Clicked()
	else:
		phline = PhantomLine.new(self.global_position)
		owner.add_child(phline)

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
