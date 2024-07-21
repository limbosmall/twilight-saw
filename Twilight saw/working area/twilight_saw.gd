extends Node2D

var things = [["res://sprites/ДУБ.png", Vector2(40, 50), "Savable", "Log","Log1", 50, 120, 5],
["res://sprites/БЕРЕЗА.png", Vector2(40, 50), "Savable", "Log", "Log2" , 30, 70, 3],
["res://sprites/сосева.png", Vector2(40, 50), "Savable", "Log", "Log3" , 10, 50, 3],
["res://sprites/Trash1.png", Vector2(40, 48), "Savable", "Trash", "Trash1" , 0, 50, 0],
["res://sprites/Trash2.png", Vector2(40, 100), "Savable", "Trash", "Trash2" , 0, 100, 0]]

var occupied_paths = [0, 0]
var path
var game_data

var rand = RandomNumberGenerator.new()
class create_log:
	extends CharacterBody2D
	
	func _init(sprite_texture: Texture, collision_size: Vector2, saving_group: String, group: String, stack_group: String , hp: int, scoreadd: int, max_stack: int):
		#set sprite
		var sprite = Sprite2D.new()
		sprite.texture = sprite_texture
		add_child(sprite)
		#set collision + layer + mask
		var col_shape = CollisionShape2D.new()
		col_shape.shape = RectangleShape2D.new()
		col_shape.shape.set_size(collision_size)
		set_collision_layer(1)
		set_collision_mask(1)
		add_child(col_shape)
		#set script + change script vars
		var script = load("res://other nodes/log1.gd")
		set_script(script)
		set("collision_size", collision_size)
		set("localsprite", sprite)
		set("localself", self)
		set("local_hp", hp)
		set("scoreadd", scoreadd)
		set("max_stack", max_stack)
		#add to group
		add_to_group(group)
		add_to_group(stack_group)
		add_to_group(saving_group)

func loader():
	var file = FileAccess.open("user://TwilightSawSaveFile.json", FileAccess.READ)
	var content = file.get_var()
	file = null
	gb.global_score = content["score"]
	gb.big_saw_dmg = content["big saw damage"]
	gb.twilight_saw_dmg = content["twilight saw damage"]
	gb.tiles_cant_spawn = content["tiles cant spawn"]
	if len(content["things"]) != 0:
		for thing in content["things"]:
			var body = create_log.new(load(thing["sprite_texture"]), thing["collision_size"], thing["saving_group"], thing["group"], thing["stack_group"], thing["hp"], thing["scoreadd"], thing["max_stack"])
			add_child(body)
			body.global_position = thing["pos"]

func _process(_delta):
	$Label.text = "Score: %s" % gb.global_score

func _ready():
	if gb.must_load_data:
		loader()
	gb.tilemap = $TileMap
	time_add()
	rand.randomize()

func time_add():
	gb.global_score += 1
	await get_tree().create_timer(0.1).timeout
	time_add()

func change_path():
	while path in occupied_paths or Vector2i(path, -2) in gb.tiles_cant_spawn:
		path = rand.randi_range(9, 13)
		if len(gb.tiles_cant_spawn) == 4:
			path = gb.tiles_cant_spawn[-1][0]
			break

func _on_timer_timeout():
	if len(gb.tiles_cant_spawn) < 4:
		var thing = rand.randi_range(0, 4)
		path = rand.randi_range(9, 13)
		var body = create_log.new(load(things[thing][0]), things[thing][1], things[thing][2], things[thing][3], things[thing][4], things[thing][5], things[thing][6], things[thing][7])
		add_child(body)
		if path in occupied_paths or Vector2i(path, -2) in gb.tiles_cant_spawn:
			change_path()
		occupied_paths[1] = occupied_paths[0]
		occupied_paths[0] = path
		body.global_position = $TileMap.map_to_local(Vector2i(path, -2))
	#$Timer.wait_time = 1.5 * (gb.game_speed ** -1)
	#$Timer.start()
	#gb.score_ratio = max(0, (gb.global_score - gb.score_threshold) / gb.score_threshold)
	#gb.speed_increase = gb.acceleration_factor * pow(gb.score_ratio, gb.score_exponent)
	#gb.game_speed = gb.base_speed + gb.speed_increase
	
