extends Node

# Пътят към файла със записа
const SAVE_PATH = "user://savegame.save"

# Речникът с прогреса на вратите
var level_progress = {
	"puzzle1": false,
	"puzzle2": false,
	"puzzle3": false,
	"puzzle4": false,
	"puzzle5": false,
	"puzzle6": false,
	"puzzle7": false,
	"puzzle8": false,
	"puzzle9": false
}

# Променлива, която помни последния решен пъзел
var last_solved_puzzle = "" 

var dir = DirAccess.open("user://")

# --- ФУНКЦИЯ ЗА ЗАПИСВАНЕ ---
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(level_progress)
		file.store_var(last_solved_puzzle)
		print("Играта е записана!")
	else:
		print("Грешка при записване!")

# --- ФУНКЦИЯ ЗА ЗАРЕЖДАНЕ (Тази ти липсваше!) ---
func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			level_progress = file.get_var()
			last_solved_puzzle = file.get_var()
			print("Играта е заредена!")
	else:
		print("Няма записана игра.")
