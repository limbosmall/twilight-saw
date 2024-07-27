extends Sprite2D

var log_group: String
var original_log
var multiply_to_log
var can_stack = false
var stacking = false

func _process(_delta):
	if len(get_parent().logs) != 0:
		for loga in get_parent().logs:
			if loga.is_in_group(log_group) and loga != original_log and loga.multiplier + original_log.multiplier <= loga.max_stack:
				can_stack = true
				multiply_to_log = loga
			else:
				can_stack = false
				multiply_to_log = null
	else:
		can_stack = false
		multiply_to_log = null
	Stacker()

func Stacker():
	if can_stack and not stacking:
		stacking = true
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.2)
	elif not can_stack and stacking:
		stacking = false
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
