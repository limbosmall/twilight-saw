extends Button

@export var max_stack: int
@export var number_to_add: float
@export var cost: int
@export var booler: bool
@export_enum("ABsaw_unlocked", "DrawSaw_unlocked",
 "ABphline_radius","ABmax_points", "DrawSaw_max_pixels",
 "BigSaw_timer_unlocked", "BigSaw_timer_speed") var property: String
var current_stack = 0

func _ready():
	get_parent().get_node("Cost").text = "Cost: %s" % cost

func _on_pressed():
	if gb.shopping and current_stack <= max_stack:
		if gb.global_score >= cost:
			gb.global_score -= cost
			#if booler:
				#gb.set(property, true)
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
