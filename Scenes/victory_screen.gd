extends Control

	
func _on_button_pressed():
	# Връща към главното меню (провери дали пътят е верен!)
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_button_2_pressed():
	get_tree().quit()
