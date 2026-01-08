extends Node2D

signal puzzle_solved

@onready var intro_label: Label = $IntroLabel
@onready var special_column: Node = $SpecialColumn

func _ready() -> void:
	# 1) Показваме текста в началото за 5 секунди
	intro_label.visible = true
	await get_tree().create_timer(3.0).timeout
	intro_label.visible = false

	# 2) Слушаме колоната (трябва тя да emit-ва signal column_touched)
	if special_column.has_signal("column_touched"):
		special_column.connect("column_touched", Callable(self, "_on_column_touched"))
	else:
		print("ERROR: SpecialColumn has no signal 'column_touched'. Did you add the script to it?")
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)
func _on_column_touched() -> void:
	print("Puzzle solved: column touched.")
	puzzle_solved.emit()
