# Door.gd
extends Area2D

# Масив с пътища към загадките
var puzzle_scenes = [
	"res://Scenes/puzzle1.tscn",
	"res://Scenes/puzzle2.tscn",
	"res://Scenes/puzzle3.tscn"
]

func _ready():
	# Свързваме сигнала за сблъсък
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	# Проверяваме дали това е играчът
	if body.name == "player" or body.is_in_group("player"):
		# Спираме движението на играча
		body.can_move = false
		
		# Избираме случайна загадка
		var random_puzzle = puzzle_scenes[randi() % puzzle_scenes.size()]
		var puzzle_scene = load(random_puzzle)
		var puzzle_instance = puzzle_scene.instantiate()
		
		# Добавяме загадката към текущата сцена
		get_tree().current_scene.add_child(puzzle_instance)
		
		# Свързваме сигналите от загадката
		puzzle_instance.connect("puzzle_solved", _on_puzzle_solved)
		puzzle_instance.connect("puzzle_closed", _on_puzzle_closed)

func _on_puzzle_solved():
	# При успешно решаване - премахваме вратата
	var player = get_tree().current_scene.get_node("player")
	if player:
		player.can_move = true
	queue_free()

func _on_puzzle_closed():
	# При затваряне - връщаме контрола на играча
	var player = get_tree().current_scene.get_node("player")
	if player:
		player.can_move = true
