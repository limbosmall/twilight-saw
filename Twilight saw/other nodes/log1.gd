extends CharacterBody2D

var localsprite
var localself
var collision_size
var local_hp = 0
var scoreadd = 100
var xadder = 1
var multiplier = 1
var max_stack = 4

var destroying = false
var clicked = false

func _process(_delta):
	if not destroying:
		move_and_collide(Vector2(0, 1) * gb.game_speed)

func Sawed(dmg):
	local_hp -= dmg
	if clicked == false and not destroying:
		clicked = true
		var tween_blink1 = self.create_tween()
		tween_blink1.parallel().tween_property(localsprite, "modulate", Color8(1, 1, 1), 0.2 * (gb.game_speed ** -1))
		tween_blink1.parallel().tween_property(localsprite, "scale", Vector2(1.2, 1.2), 0.2 * (gb.game_speed ** -1))
		await tween_blink1.finished
		var tween_blink2 = self.create_tween()
		tween_blink2.parallel().tween_property(localsprite, "modulate", Color(1,1,1,1), 0.2)
		tween_blink2.parallel().tween_property(localsprite, "scale", Vector2(1, 1), 0.2)
		await tween_blink2.finished
		clicked = false
	if local_hp <= 0 and not destroying:
		set_collision_layer(0)
		set_collision_mask(0)
		gb.global_score += xadder * multiplier * (scoreadd * int(localself.is_in_group("Log")) -scoreadd * int(localself.is_in_group("Trash")))
		var tween = self.create_tween()
		tween.tween_property(localsprite, "modulate", Color(1,1,1,0), 0.5 * (gb.game_speed ** -1))
		await tween.finished
		self.queue_free()

func Destroy():
	if local_hp > 0:
		destroying = true
		set_collision_layer(0)
		set_collision_mask(0)
		var tween_move = self.create_tween()
		if tween_move.is_running():
			gb.global_score += 100
			tween_move.tween_property(localself, "position", Vector2(375, 371), 0.5 * (gb.game_speed ** -1))
			await tween_move.finished
			var tween_destroy = self.create_tween()
			tween_destroy.parallel().tween_property(localsprite, "modulate", Color(1,1,1,0), 0.5 * (gb.game_speed ** -1))
			tween_destroy.parallel().tween_property(localself, "scale", Vector2(0.001, 0.001), 0.5 * (gb.game_speed ** -1))
			await tween_destroy.finished
			self.queue_free()
