extends Node2D

func _ready():
	print("--- СТАРТИРАНЕ НА ГЛАВНАТА СЦЕНА ---")
	
	# 1. Зареждаме записа
	Global.load_game()
	Global.level_progress["puzzle3"] = false
	Global.save_game()
	print("Прогрес след зареждане: ", Global.level_progress)
	print("Последен пъзел: ", Global.last_solved_puzzle)

	# 2. Скриваме отворените врати в началото
	if has_node("openDoor"): 
		$openDoor.visible = false
	else:
		print("ГРЕШКА: Не намирам 'openDoor' в сцената!")
		
	if has_node("openDoor2"): 
		$openDoor2.visible = false
	else:
		print("ГРЕШКА: Не намирам 'openDoor2' в сцената!")
	
	if has_node("openDoor3"): 
		$openDoor3.visible = false
	else:
		print("ГРЕШКА: Не намирам 'openDoor3' в сцената!")

	# --- ПРОВЕРКА ЗА ПЪЗЕЛ 1 ---
	if Global.level_progress.has("puzzle1") and Global.level_progress["puzzle1"] == true:
		print("Пъзел 1 е РЕШЕН. Опитвам се да отворя Врата 1...")
		
		if has_node("openDoor"):
			$openDoor.visible = true
			print(" -> 'openDoor' стана видима.")
		
		if has_node("Door"):
			$Door.queue_free()
			print(" -> 'Door' (затворената) е изтрита.")
		else:
			print(" -> ГРЕШКА: Не намирам 'Door', за да я изтрия!")
	else:
		print("Пъзел 1 НЕ е решен според записа.")

	# --- ПРОВЕРКА ЗА ПЪЗЕЛ 2 ---
	if Global.level_progress.has("puzzle2") and Global.level_progress["puzzle2"] == true:
		print("Пъзел 2 е РЕШЕН. Опитвам се да отворя Врата 2...")
		
		if has_node("openDoor2"):
			$openDoor2.visible = true
			print(" -> 'openDoor2' стана видима.")
			
		# ТУК Е ВАЖНИЯТ МОМЕНТ С ИМЕНАТА
		# Пробваме различни варианти, защото на снимките ти името беше странно
		if has_node("door2"):
			$door2.queue_free()
			print(" -> 'door2' е изтрита.")
		elif has_node("`door2"): # Проверка за името с апострофа
			get_node("`door2").queue_free()
			print(" -> '`door2' (с апострофа) е изтрита.")
		else:
			print(" -> ГРЕШКА: Не намирам затворената врата 2! Провери името ѝ!")
	else:
		print("Пъзел 2 НЕ е решен според записа.")

	# --- ПОЗИЦИОНИРАНЕ ---
	if Global.last_solved_puzzle == "puzzle1":
		if has_node("player"):
			$player.position = Vector2(158, 2473)
			print("Героят е преместен пред Врата 1.")
		elif has_node("playe"):
			$playe.position = Vector2(158, 2473)
			print("Героят (playe) е преместен пред Врата 1.")
			
	elif Global.last_solved_puzzle == "puzzle2":
		if has_node("player"):
			$player.position = Vector2(-531, 1891)
			print("Героят е преместен пред Врата 2.")
		elif has_node("playe"):
			$playe.position = Vector2(-531, 1891)
			
	if Global.level_progress.has("puzzle3") and Global.level_progress["puzzle3"] == true:
		print("Пъзел 3 е РЕШЕН. Опитвам се да отворя Врата 3...")
		if has_node("openDoor3"):
			$openDoor3.visible = true
			print(" -> 'openDoor3' стана видима.")
		else:
			print(" -> ГРЕШКА: Не намирам 'openDoor3'!")
		if has_node("door3"):
			$door3.queue_free()
			print(" -> 'door3' е изтрита.")
		else:
			print(" -> ГРЕШКА: Не намирам затворената врата 3! Провери името ѝ!")
	else:
		print("Пъзел 3 НЕ е решен според записа.")
