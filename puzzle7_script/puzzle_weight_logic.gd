extends Node2D

@onready var plates := $"../Plates".get_children()
@onready var exit = get_node("../Exit")

var puzzle_solved := false

func _ready():
	for plate in plates:
		plate.plate_changed.connect(check_puzzle)
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)

	check_puzzle()

func check_puzzle():
	print("🔍 Проверка на пъзела:")
	for plate in plates:
		print("  Плоча:", plate.name, "→ правилен:", plate.is_correct())
		if not plate.is_correct():
			return
	print("✅ PUZZLE SOLVED")
	exit.set_active(true)
