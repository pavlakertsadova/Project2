extends Node2D

signal puzzle_solved
signal puzzle_closed

@export var player: Node2D

@onready var interact_area: Area2D = $InteractObject

@onready var intro_label: Label = $IntroLabel
@onready var riddle_label: Label = $RiddleLabel
@onready var answer_edit: LineEdit = $AnswerEdit
@onready var feedback_label: Label = $FeedbackLabel

@onready var sfx_door: AudioStreamPlayer2D = $AudioStreamPlayer2D

var can_interact := false
var riddle_open := false


func _ready() -> void:
	# Влизаш в сцената → виждаш intro текста
	intro_label.visible = true

	# Гатанката е скрита в началото
	riddle_label.visible = false
	answer_edit.visible = false
	feedback_label.visible = false

	# Зона на предмета
	interact_area.body_entered.connect(_on_interact_body_entered)
	interact_area.body_exited.connect(_on_interact_body_exited)
	
	await get_tree().create_timer(4.0).timeout
	if not riddle_open:
		intro_label.visible = false

	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)


func _process(_delta: float) -> void:
	# Ако гатанката вече е отворена, не слушаме за E
	if riddle_open:
		return

	# Натискаш E само ако си до предмета
	if can_interact and Input.is_action_just_pressed("interact"):
		_open_riddle()


func _on_interact_body_entered(body: Node) -> void:
	if body == player and not riddle_open:
		can_interact = true


func _on_interact_body_exited(body: Node) -> void:
	if body == player:
		can_interact = false


func _open_riddle() -> void:
	riddle_open = true
	can_interact = false

	# скриваме intro текста
	intro_label.visible = false

	# показваме гатанката
	riddle_label.visible = true
	answer_edit.visible = true
	feedback_label.visible = true
	feedback_label.text = ""
	answer_edit.text = ""
	answer_edit.grab_focus()


func _on_close_pressed() -> void:
	puzzle_closed.emit()
	queue_free()


func _on_answer_edit_text_submitted(new_text: String) -> void:
	var answer := new_text.strip_edges().to_lower()

	var correct_answers := [
		"echo",
		"an echo",
		"the echo",
		"echoes"
	]

	if answer in correct_answers:
		feedback_label.text = "Correct!"
		Global.level_progress["puzzle3"] = true
		Global.last_solved_puzzle = "puzzle3"
		Global.checkpoint_id = "Checkpoint_3"
		Global.save_game()
		sfx_door.play()
		await get_tree().create_timer(0.15).timeout
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")
		puzzle_solved.emit()
	else:
		feedback_label.text = "Try again."
		answer_edit.select_all()
		answer_edit.grab_focus()
