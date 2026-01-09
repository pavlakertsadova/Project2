extends Area2D

@export var is_correct_answer = false
var is_active = false

func _ready():
	# Скриваме етикета при старт, ако съществува
	if has_node("Label"):
		$Label.visible = false
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)

# Тази функция се вика от Гроба
func activate_stone():
	print("Паметникът ", name, " е активиран!")
	is_active = true
	
	# 1. ОПРАВЯНЕ НА ЛЕЙБЪЛИТЕ
	var label = get_node_or_null("Label")
	if label:
		label.visible = true
		print(" -> Етикетът на ", name, " се показа! Текст: ", label.text)
	else:
		print(" -> ГРЕШКА: В ", name, " НЯМА дете с име 'Label'!")

func _on_body_entered(body):
	# Ако не е активен, игнорираме всичко
	if is_active == false:
		return

	# 2. ПРОВЕРКА ДАЛИ Е ИГРАЧ (Много важно!)
	# Използваме същата логика като при гроба, за да сме сигурни
	if body.name == "player" or body.is_in_group("player"):
		print("Играчът стъпи върху отговор: ", name)
		
		if is_correct_answer:
			print("ВЕРЕН ОТГОВОР!")
			Global.level_progress["puzzle4"] = true
			Global.last_solved_puzzle = "puzzle4"
			Global.checkpoint_id = "Checkpoint_4"
			Global.save_game()
			call_deferred("go_home")
		else:
			print("ГРЕШЕН ОТГОВОР!")
			# Връщаме героя леко назад, вместо да рестартираме веднага
			# (за да не забива в цикъл)
			body.position = Vector2(100, 300) # Сложи координатите на входа на стаята!

func go_home():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")
