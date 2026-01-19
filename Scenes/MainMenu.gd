extends Control

# Дръпни референции към контейнерите (ако са с други имена, оправи ги тук)
@onready var menu_buttons = $VBoxContainer  # Контейнерът с Start/Exit
@onready var settings_menu = $SettingsMenu  # Панелът с настройките



func _ready():
	# Уверяваме се, че при старт настройките са скрити
	settings_menu.visible = false
	menu_buttons.visible = true
	AudioManager.set_mode(AudioManager.MusicMode.MENU)
	# Уверяваме се, че при старт настройките са скрити
	settings_menu.visible = false
	var title = $Label
	title.add_theme_font_size_override("font_size", 36)
	title.pivot_offset = title.size / 2
	var tween = create_tween().set_loops()
	tween.tween_property(title, "scale", Vector2(1.02, 1.02), 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title, "scale", Vector2(1, 1), 1.0).set_trans(Tween.TRANS_SINE)
	menu_buttons.visible = true
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		# Ако възелът ти се казва CheckButton (промени името ако е друго)
		$SettingsMenu/VBoxContainer/CheckButton.button_pressed = true


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

# --- НОВИТЕ ФУНКЦИИ ---

func _on_settings_button_pressed():
	# Скриваме главното меню, показваме настройките
	menu_buttons.visible = false
	settings_menu.visible = true
	var title = $Label
	title.visible = false

func _on_back_button_pressed():
	# Обратното
	menu_buttons.visible = true
	settings_menu.visible = false
	var title = $Label
	title.visible = true

func _on_h_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Master")
	
	# Ако плъзгачът е на 0, заглушаваме напълно (Mute)
	if value == 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		# Превръщаме линейната стойност (0-1) в децибели (Logarithmic)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
