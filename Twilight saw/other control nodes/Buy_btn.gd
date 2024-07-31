extends Button

@export var max_stack: int
@export var number_to_add: float
@export var cost: int
@export var booler: bool
@export var multi_upgrade: bool
@export_enum("ABsaw_unlocked", "DrawSaw_unlocked",
 "ABphline_radius","ABmax_points", "DrawSaw_max_pixels",
 "BigSaw_timer_unlocked", "BigSaw_timer_speed", "BigSaw_dmg",
"twilight_saw_dmg") var property: String
@export var unlock_upgrades: Array
var current_stack = 0
var endpt = Vector2i.ZERO
var moved_upgrades = []

func _ready():
	get_parent().get_node("Cost").text = "Cost: %s" % cost

func _on_pressed():
	if gb.shopping and current_stack < max_stack:
		if gb.global_score >= cost:
			gb.global_score -= cost
			if len(unlock_upgrades) != 0:
				var scroller = get_parent().get_parent().get_parent().get_parent()
				var current_lines = 0
				var current_upgrades = 0
				for child in scroller.get_children():
					current_lines += 1
					for nchild in child.get_child(0).get_children():
						if not nchild.is_in_group("Gap"):
							current_upgrades += 1
				if ceil((current_upgrades + len(unlock_upgrades)) / 3.0) > current_lines:
					while ceil((current_upgrades + len(unlock_upgrades)) / 3.0) > current_lines:
						scroller.add_child(preload("res://other control nodes/line_marg.tscn").instantiate())
						current_lines += 1
				procedural_movement(1, scroller, current_lines)
				procedural_movement(2, scroller, current_lines)
				procedural_movement(3, scroller, current_lines)

			if !booler:
				gb.set(property, gb.get(property) + number_to_add)
			cost += cost + (gb.global_score % 1000) * 5
			get_parent().get_node("Cost").text = "Cost: %s" % cost
			current_stack += 1
			if current_stack >= max_stack:
				get_parent().get_node("Cost").text = "Max Level"
				if booler:
					self.toggle_mode = true
					self.text = "Off"
				else:
					disabled = true
	elif gb.shopping and current_stack >= max_stack and booler:
		gb.set(property, !gb.get(property))
		if text == "Off":
			text = "On"
		else:
			text = "Off"

func procedural_movement(mode: int, scroller, current_lines):
	var a = 1
	for i in range(scroller.get_children().find(get_parent().get_parent().get_parent()), current_lines):
		var start_index = 0
		if mode == 1:
			if get_parent() in scroller.get_children()[i].get_child(0).get_children():
				if scroller.get_children()[i].get_child(0).get_children().find(get_parent()) == 4:
					continue
				start_index = scroller.get_children()[i].get_child(0).get_children().find(get_parent()) + 1
			for j in range(start_index, len(scroller.get_children()[i].get_child(0).get_children())):
				if not scroller.get_children()[i].get_child(0).get_children()[j].is_in_group("Gap"):
					moved_upgrades.append(scroller.get_children()[i].get_child(0).get_children()[j])
			for node in moved_upgrades:
				if node.get_parent() == scroller.get_children()[i].get_child(0):
					scroller.get_children()[i].get_child(0).remove_child(node)
			
		elif mode == 2:
			start_index = -2
			if get_parent() in scroller.get_children()[i].get_child(0).get_children():
				if scroller.get_children()[i].get_child(0).get_children().find(get_parent()) == 4:
					continue
				start_index = scroller.get_children()[i].get_child(0).get_children().find(get_parent())
			
			for j in range(1, 6 - len(scroller.get_children()[i].get_child(0).get_children())):
				var child = load(str(unlock_upgrades.pop_front()))
				var insta_child = child.instantiate()
				if insta_child.get_node("BuyBtn").multi_upgrade:
					if gb.twilight_saw_damage_unlocked:
						if start_index + 2 * j == 4:
							endpt = Vector2i(-2, i + 1)
						else:
							endpt = Vector2i(start_index + 2 * j - 1, i)
						break
					else:
						gb.twilight_saw_damage_unlocked = true
				scroller.get_children()[i].get_child(0).add_child(insta_child)
				scroller.get_children()[i].get_child(0).move_child(insta_child, start_index + 2 * j)
				if len(unlock_upgrades) == 0:
					if start_index + 2 * j == 4:
						endpt = Vector2i(-1, i + 1)
					else:
						endpt = Vector2i(start_index + 2 * j, i)
					break
			if len(unlock_upgrades) == 0:
				break
	if mode == 3 and len(moved_upgrades) != 0:
		var start_index = endpt.x + 1
		for i in range(endpt.y, current_lines):
			for j in range(start_index, 5):
				if j % 2 == 0:
					var mupgr = moved_upgrades.pop_front()
					scroller.get_children()[i].get_child(0).add_child(mupgr)
					scroller.get_children()[i].get_child(0).move_child(mupgr, j)
				if len(moved_upgrades) == 0:
					break
			start_index = 0
			if len(moved_upgrades) == 0:
					break
