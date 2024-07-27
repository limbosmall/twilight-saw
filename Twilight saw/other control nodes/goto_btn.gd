extends Button

@export_file("*.tscn","*.scn","*.res") var scene_to_load := ""
@export var load_btn := false
@export var newgame_btn := false

func _on_pressed():
	if newgame_btn:
		var file = FileAccess.open("user://TwilightSawSaveFile.json", FileAccess.WRITE)
		file.store_string("{}")
		file = null
	if load_btn:
		gb.must_load_data = true
	get_tree().change_scene_to_file(scene_to_load)

func  _ready():
	
	if load_btn and !gb.has_saved_data:
		self.disabled = true

func _on_tree_exited():
	self.pressed.disconnect(_on_pressed)

func _on_tree_entered():
	self.pressed.connect(_on_pressed)
