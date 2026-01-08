extends Node2D

var text_start = "Observe the terrain carefully.\nMemorize it.\nWhen ready, press 'E'."
var text_find = "Now find the difference!\nTouch the object that wasn't here before."

var state = "observing"
var player_ref = null

func _ready():
	# 1. Скриваме тайния обект
	if has_node("SecretObject"):
		$SecretObject.visible = false
		$SecretObject/CollisionShape2D.set_deferred("disabled", true)

	# 2. НАМИРАМЕ ИГРАЧА АВТОМАТИЧНО (Без тригер)
	# Търсим първия обект в групата "player"
	player_ref = get_tree().get_first_node_in_group("player")
	
	if player_ref:
		# Показваме първия текст веднага!
		update_label(text_start)
	else:
		print("Грешка: Не намирам играча в групата 'player'!")
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)

func _input(event):
	# Чакаме натискане на E
	if state == "observing" and Input.is_key_pressed(KEY_E):
		print("Клавиш E натиснат!")
		start_search()

func start_search():
	state = "searching"
	
	# Показваме обекта
	$SecretObject.visible = true
	$SecretObject/CollisionShape2D.set_deferred("disabled", false)
	
	# Сменяме текста
	update_label(text_find)

# Помощна функция за текста
func update_label(text_to_show):
	# Проверяваме дали сме намерили играча и дали има етикет
	if player_ref and player_ref.has_node("taskLabel1"):
		var lbl = player_ref.get_node("taskLabel1")
		lbl.text = text_to_show
		lbl.visible = true

# Тази функция се вика от тайния обект (SecretObject)
func finish_puzzle():
	print("ПОБЕДА!")
	Global.level_progress["puzzle5"] = true
	Global.last_solved_puzzle = "puzzle5"
	Global.checkpoint_id = "Checkpoint_5"
	Global.save_game()
	call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")
