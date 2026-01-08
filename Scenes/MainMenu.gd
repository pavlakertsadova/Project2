extends Control

func _ready():
	AudioManager.set_mode(AudioManager.MusicMode.MENU)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
