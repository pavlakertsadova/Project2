extends Node2D

func _ready():
	# --- СКРИВАМЕ ОТВОРЕНИТЕ ВРАТИ В НАЧАЛОТО ---
	if has_node("openDoor"): $openDoor.visible = false
	if has_node("openDoor2"): $openDoor2.visible = false # <--- Нова врата

	# --- ЛОГИКА ЗА ПЪЗЕЛ 1 ---
	if Global.level_progress.has("puzzle1") and Global.level_progress["puzzle1"] == true:
		if has_node("openDoor"): $openDoor.visible = true
		if has_node("Door"): $Door.queue_free()

	# --- ЛОГИКА ЗА ПЪЗЕЛ 2 (ТОВА ДОБАВЯМЕ СЕГА) ---
	if Global.level_progress.has("puzzle2") and Global.level_progress["puzzle2"] == true:
		
		# 1. Показваме отворената врата 2
		if has_node("openDoor2"):
			$openDoor2.visible = true
			
		# 2. Махаме затворената врата 2
		# Увери се, че името тук съвпада с това в лявото меню!
		# На една от снимките ти се казваше "`door2", на друга "door2". 
		# Ако е "door2", ползвай това:
		if has_node("door2"):
			$door2.queue_free()
