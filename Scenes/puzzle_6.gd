extends Node2D

signal puzzle_solved

var main_scene_path = "res://Scenes/node_2d.tscn"

@export var player: CharacterBody2D
@onready var finish_zone: Area2D = $FinishZone
@onready var hint_label: Label = $HintLabel

@onready var riddle_label2: Label = $RiddleLabel2
@onready var answer_edit2: LineEdit = $AnswerEdit2
@onready var feedback_label2: Label = $FeedbackLabel2

var player_in_zone := false
var stop_time := 0.0
const REQUIRED_STOP_TIME := 0.7

var movement_part_done := false


func _ready() -> void:
	hint_label.visible = true

	riddle_label2.visible = false
	answer_edit2.visible = false
	feedback_label2.visible = false

	finish_zone.body_entered.connect(_on_finish_entered)
	finish_zone.body_exited.connect(_on_finish_exited)

	# Enter в LineEdit
	answer_edit2.text_submitted.connect(_on_answer_submitted)
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)


func _process(delta: float) -> void:
	if movement_part_done:
		return
	if not player_in_zone:
		return

	if player.velocity.length() > 0.1:
		stop_time = 0.0
		return

	stop_time += delta
	if stop_time >= REQUIRED_STOP_TIME:
		_start_riddle_part()


func _on_finish_entered(body: Node) -> void:
	if body == player:
		player_in_zone = true
		stop_time = 0.0
		hint_label.visible = true


func _on_finish_exited(body: Node) -> void:
	if body == player:
		player_in_zone = false
		stop_time = 0.0
		hint_label.visible = false


func _start_riddle_part() -> void:
	# да се случи само веднъж
	movement_part_done = true

	# скриваме подсказката
	hint_label.visible = false

	# показваме гатанката
	riddle_label2.visible = true
	answer_edit2.visible = true
	feedback_label2.visible = true
	feedback_label2.text = ""
	answer_edit2.text = ""
	answer_edit2.grab_focus()


func _on_answer_submitted(text: String) -> void:
	var answer := text.strip_edges().to_lower()

	# правилен отговор за тази гатанка:
	# "keyboard"
	if answer == "keyboard" or answer == "a keyboard":
		Global.level_progress["puzzle6"] = true
		Global.last_solved_puzzle = "puzzle6"
		Global.checkpoint_id = "Checkpoint_6"
		Global.save_game()
		get_tree().change_scene_to_file(main_scene_path)
		puzzle_solved.emit()
	else:
		feedback_label2.text = "Try again."
		answer_edit2.select_all()
		answer_edit2.grab_focus()
