extends Node2D

var things = [["res://sprites/Log1.png", Vector2(40, 120), "Log","Log1" , 50],
 ["res://sprites/Log2.png", Vector2(40, 77), "Log", "Log2" , 30], ["res://sprites/Log3.png", Vector2(40, 57), "Log", "Log3" , 10],
["res://sprites/Trash1.png", Vector2(40, 48), "Trash", "Trash1" , 0], ["res://sprites/Trash2.png", Vector2(40, 100), "Trash", "Trash2" , 0]]

var occupied_paths = [0, 0]
var path

var rand = RandomNumberGenerator.new()
class create_log:
	extends CharacterBody2D
	
	func _init(sprite_texture: Texture, collision_size: Vector2, group: String, stack_group: String , hp: int):
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
		set("localsprite", sprite)
		set("localself", self)
		set("local_hp", hp)
		#add to group
		add_to_group(group)
		add_to_group(stack_group)

func _process(_delta):
	$Label.text = "Score: %s" % gb.global_score

func _ready():
	time_add()
	rand.randomize()

func time_add():
	gb.global_score += 1
	await get_tree().create_timer(0.1).timeout
	time_add()

func change_path():
	while path in occupied_paths:
		path = rand.randi_range(9, 13)

func _on_timer_timeout():
	var thing = rand.randi_range(0, 4)
	path = rand.randi_range(9, 13)
	var body = create_log.new(load(things[thing][0]), things[thing][1], things[thing][2], things[thing][3], things[thing][4])
	add_child(body)
	if path in occupied_paths:
		change_path()
	occupied_paths[1] = occupied_paths[0]
	occupied_paths[0] = path
	body.global_position = $TileMap.map_to_local(Vector2i(path, -2))
	#gb.score_ratio = max(0, (gb.global_score - gb.score_threshold) / gb.score_threshold)
	#gb.speed_increase = gb.acceleration_factor * pow(gb.score_ratio, gb.score_exponent)
	#gb.game_speed = gb.base_speed + gb.speed_increase
	
