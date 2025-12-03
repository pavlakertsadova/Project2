extends Area2D

var riddle_text = "In ancient legends, every wrong step in the labyrinth leads to me.\nI have the strength of a man, but the head of a bull.\nWho am I?"

# Тази функция проверява логиката, независимо какво е влязло
func check_object(obj):
	print("Проверка на обект: ", obj.name)
	
	# Проверяваме името ИЛИ групата
	if obj.name == "player" or obj.is_in_group("player") or obj.get_parent().name == "player":
		print("!!! ГЕРОЯТ Е ТУК !!!")
		
		# Търсим етикета (може да е в obj или в родителя му)
		var target = obj
		if obj.get_parent().name == "player": target = obj.get_parent()
		
		var label = target.get_node_or_null("taskLabel1")
		if label:
			label.text = riddle_text
			label.visible = true
		print("--- Търся камъните... ---")
		# Активираме отговорите
		var stone1 = get_node_or_null("../answer1")
		if stone1:
			print(" -> НАМЕРИХ 'answer1'! Активирам го...")
			stone1.activate_stone()
		else:
			print(" -> ГРЕШКА: Не намирам '../answer1'. Провери името!")
		if get_node_or_null("../answer1"): get_node("../answer1").activate_stone()
		if get_node_or_null("../answer2"): get_node("../answer2").activate_stone()
		if get_node_or_null("../answer3"): get_node("../answer3").activate_stone()
		if get_node_or_null("../answer4"): get_node("../answer4").activate_stone()
		
		$CollisionShape2D.set_deferred("disabled", true)

# Свържи body_entered тук
func _on_body_entered(body):
	check_object(body)

# Свържи area_entered тук (Ако героят е Area2D)
func _on_area_entered(area):
	check_object(area)
