extends Button

@export var max_stack: int
@export var number_to_add: int
@export var cost: int
@export var floater: float
@export_enum("ABsaw_unlocked", "DrawSaw_unlocked",
 "ABphline_radius","ABmax_points", "DrawSaw_max_pixels") var property: String
var current_stack = 0

func _ready():
	get_parent().get_node("Cost").text = "Cost: %s" % cost

func _on_pressed():
	if gb.shopping:
		if gb.global_score >= cost:
			gb.global_score -= cost
			if floater:
				gb.set(property, true)
			else:
				gb.set(property, gb.get(property) + number_to_add)
			cost += cost + (gb.global_score % 1000) * 5
			get_parent().get_node("Cost").text = "Cost: %s" % cost
			current_stack += 1
			if current_stack >= max_stack:
				disabled = true
				get_parent().get_node("Cost").text = "Max Level"
