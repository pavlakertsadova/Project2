extends Node2D

@onready var intro_label = $IntroLabel
@export var columns: Array[SpecialColumn] = []  # подредени 1,2,3,4 в Inspector
var step := 0

var main_scene_path := "res://Scenes/node_2d.tscn"

func _ready() -> void:
	intro_label.visible = true
	await get_tree().create_timer(3.0).timeout
	intro_label.visible = false
	for c in columns:
		c.set_active(false)
		c.column_touched.connect(_on_column_touched)

	step = 0
	if columns.size() > 0:
		columns[0].set_active(true)

func _on_column_touched(col: SpecialColumn) -> void:
	if col != columns[step]:
		return

	col.set_active(false)
	step += 1

	if step < columns.size():
		columns[step].set_active(true)
	else:
		_finish_puzzle()

func _finish_puzzle() -> void:
	Global.level_progress["puzzle9"] = true
	Global.last_solved_puzzle = "puzzle9"
	Global.checkpoint_id = "Checkpoint_9"
	Global.save_game()

	get_tree().change_scene_to_file(main_scene_path)
