extends Area2D

# Текстът на загадката
var riddle_text = "In ancient legends, every wrong step in the labyrinth leads to me.\nI have the strength of a man, but the head of a bull.\nWho am I?"

func _on_body_entered(body):
	# Проверяваме дали влязлото тяло е играчът (по име или група)
	if body.name == "player" or body.is_in_group("player"):
		print("!!! ГЕРОЯТ ВЛЕЗЕ В ГРОБА !!!")
		
		# 1. Сменяме текста в етикета на героя
		# (Увери се, че етикетът в героя се казва 'taskLabel1')
		var target = body
		if body.get_parent().name == "player": target = body.get_parent() # За всеки случай
		
		var label = target.get_node_or_null("taskLabel1")
		if label:
			label.text = riddle_text
			label.visible = true
		else:
			print("ГРЕШКА: Не намирам 'taskLabel1' в героя!")
			
		# 2. Активираме отговорите (Паметниците)
		# Увери се, че пътищата "../answer1" са верни (малки букви)
		if get_node_or_null("../answer1"): get_node("../answer1").activate_stone()
		if get_node_or_null("../answer2"): get_node("../answer2").activate_stone()
		if get_node_or_null("../answer3"): get_node("../answer3").activate_stone()
		if get_node_or_null("../answer4"): get_node("../answer4").activate_stone()
		
		# Изключваме колизията на гроба, за да не се повтаря
		$CollisionShape2D.set_deferred("disabled", true)
