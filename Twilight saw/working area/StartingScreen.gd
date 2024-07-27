extends Control

func _ready():
	if OS.get_name() == "Web":
		$MarginContainer/VBoxContainer/Exit_btn.visible = false

func _on_exit_btn_pressed():
	get_tree().quit()
