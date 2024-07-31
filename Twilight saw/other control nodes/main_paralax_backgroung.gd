extends SubViewportContainer

func _process(delta):
	$subview/paralax.scroll_offset.x -= 100 * delta
