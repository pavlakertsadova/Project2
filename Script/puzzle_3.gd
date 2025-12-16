extends Node2D

signal puzzle_solved
signal puzzle_closed

@export var player: Node2D
@export var grass_layer: TileMapLayer

@onready var intro_label: Label = $IntroLabel
@onready var riddle_label: Label = $RiddleLabel
@onready var answer_edit: LineEdit = $AnswerEdit
@onready var feedback_label: Label = $FeedbackLabel

var first_part_solved := false

func _ready() -> void:
	intro_label.visible = true
	riddle_label.visible = false
	answer_edit.visible = false
	feedback_label.visible = false


	await get_tree().create_timer(5.0).timeout
	if not first_part_solved:
		intro_label.visible = false


func _process(_delta: float) -> void:
	if first_part_solved:
		return

	if Input.is_action_just_pressed("interact"):
		if _is_player_on_grass():
			_on_first_part_solved()
		else:
			print("That is not it.")


func _is_player_on_grass() -> bool:
	if player == null or grass_layer == null:
		return false

	# точка при краката
	var foot_pos: Vector2 = player.global_position + Vector2(0, 14)

	# TileMapLayer: world -> local -> map
	var local_pos: Vector2 = grass_layer.to_local(foot_pos)
	var tile_coords: Vector2i = grass_layer.local_to_map(local_pos)

	return grass_layer.get_cell_source_id(tile_coords) != -1


func _on_first_part_solved() -> void:
	first_part_solved = true
	intro_label.visible = false
	riddle_label.visible = true
	answer_edit.visible = true
	feedback_label.visible = true
	feedback_label.text = ""
	answer_edit.text = ""
	answer_edit.grab_focus()
	print("Puzzle part 1 solved: grass touched.")


func _on_close_pressed():
	puzzle_closed.emit()
	queue_free()


func _on_answer_edit_text_submitted(new_text: String) -> void:
	var answer := new_text.strip_edges().to_lower()

	var correct_answers := [
		"eyes",
		"eye",
		"your eyes"
	]
	if answer in correct_answers:
		feedback_label.text = "Correct!"
		Global.level_progress["puzzle3"] = true
		Global.last_solved_puzzle = "puzzle3"
		Global.save_game()
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")
	else:
		feedback_label.text = "Try again."
		answer_edit.select_all()
		answer_edit.grab_focus()
	
	
