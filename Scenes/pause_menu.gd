extends CanvasLayer


@onready var music_button: Button = $FramePanel/Panel/VBoxContainer/MusicButton
@onready var sfx_button: Button = $FramePanel/Panel/VBoxContainer/SFXButton
@onready var resume_button: Button = $FramePanel/Panel/VBoxContainer/ResumeButton
@onready var quit_button: Button = $FramePanel/Panel/VBoxContainer/QuitButton
@onready var panel: Control = $FramePanel

var music_on := true

func _ready() -> void:
	# UI трябва да работи и когато играта е paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	if resume_button.pressed.is_connected(_on_resume_button_pressed):
		resume_button.pressed.disconnect(_on_resume_button_pressed)
	resume_button.pressed.connect(_on_resume_button_pressed)

func _on_pause_button_pressed() -> void:
	_pause_game()

func _on_resume_button_pressed() -> void:
	_resume_game()
	print("RESUME CLICK")

func _on_music_button_pressed() -> void:
	music_on = !music_on

	# mute/unmute на Master bus (0)
	AudioServer.set_bus_mute(0, not music_on)

	music_button.text = "Music: ON" if music_on else "Music: OFF"

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _pause_game() -> void:
	get_tree().paused = true
	panel.visible = true

func _resume_game() -> void:
	get_tree().paused = false
	panel.visible = false

func _input(event):
	if event.is_action_pressed("pause_game"):
		if panel.visible:
			_resume_game()
		else:
			_pause_game()
