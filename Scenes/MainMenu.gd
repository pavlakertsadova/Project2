extends Control

@onready var menu_buttons = $VBoxContainer  # Контейнерът с Start/Exit
@onready var settings_menu = $SettingsMenu

func _ready():
	# Уверяваме се, че при старт настройките са скрити
	settings_menu.visible = false
	menu_buttons.visible = true
	AudioManager.set_mode(AudioManager.MusicMode.MENU)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	# Скриваме главното меню, показваме настройките
	menu_buttons.visible = false
	settings_menu.visible = true

func _on_back_button_pressed():
	# Обратното
	menu_buttons.visible = true
	settings_menu.visible = false
