extends Node

@export_group("Player Settings")
@export var player: Node2D

@export_group("Doors Configuration")
# Тук ще е списъкът с всички 9 затворени врати
@export var closed_doors: Array[Node2D]

# Тук ще е списъкът с всички 9 отворени врати (спрайтовете)
@export var open_doors: Array[Node2D]

@export_group("Spawn Positions")
# Тук са координатите, където героят се появява след всеки пъзел
@export var spawn_positions: Array[Vector2]

func _ready():
	# 1. Зареждаме записа
	Global.load_game()
	
	# 2. Обновяваме нивото
	update_level()

func update_level():
	# Скриваме всички отворени врати за начало (безопасност)
	for door in open_doors:
		if door: door.visible = false

	# --- ЦИКЪЛ ЗА ВСИЧКИ 9 ПЪЗЕЛА ---
	# Този код проверява автоматично от Puzzle 1 до Puzzle 9
	for i in range(1, 10): 
		var puzzle_key = "puzzle" + str(i) # Създава "puzzle1", "puzzle2"...
		
		# Ако пъзелът е решен...
		if Global.level_progress.has(puzzle_key) and Global.level_progress[puzzle_key] == true:
			
			# Намираме правилния индекс в списъка (Пъзел 1 е индекс 0)
			var list_index = i - 1 
			
			# 1. Махаме затворената врата
			if list_index < closed_doors.size() and closed_doors[list_index] != null:
				closed_doors[list_index].queue_free()
			
			# 2. Показваме отворената врата
			if list_index < open_doors.size() and open_doors[list_index] != null:
				open_doors[list_index].visible = true

	# --- ПОЗИЦИЯ НА ГЕРОЯ ---
	if Global.last_solved_puzzle != "" and player:
		# Взимаме номера на последния пъзел (напр. от "puzzle5" взимаме 5)
		var puzzle_num_str = Global.last_solved_puzzle.replace("puzzle", "")
		var index = int(puzzle_num_str) - 1 # Вадим 1, за да стане индекс (0-8)
		
		# Телепортираме героя
		if index < spawn_positions.size():
			player.position = spawn_positions[index]
