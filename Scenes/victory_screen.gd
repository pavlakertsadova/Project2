extends Control
func _ready():
	AudioManager.set_mode(AudioManager.MusicMode.FINAL)
	# --- 1. ПЪРВИЯТ НАДПИС ---
	# Върнахме се към $Label, защото вече не е в контейнера
	var label1 = $Label 
	
	# Важно: Задаваме центъра на въртене точно в средата на текста
	label1.pivot_offset = label1.size / 2
	
	# Анимация
	var tween1 = create_tween().set_loops()
	tween1.tween_property(label1, "scale", Vector2(1.1, 1.1), 1.0).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(label1, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE)

	# --- 2. ВТОРИЯТ НАДПИС ---
	var label2 = $Label2
	
	label2.pivot_offset = label2.size / 2
	
	var tween2 = create_tween().set_loops()
	tween2.tween_property(label2, "scale", Vector2(1.1, 1.1), 1.0).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(label2, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE)
	
func _on_button_pressed():
	# Връща към главното меню (провери дали пътят е верен!)
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_button_2_pressed():
	get_tree().quit()
