extends Area2D

# Текстът на гатанката
var riddle_text = "Three sisters watch the path, but two are deceivers. The sister standing near death looks upon disappointment. The sister standing near life looks upon a trap. Only the sister standing near gold sees the way out. Follow her eyes and touch what they observe."

func _on_body_entered(body):
	# Проверяваме дали влязлото тяло е играчът
	if body.name == "player":
		# Търсим етикета вътре в героя
		var label = body.get_node_or_null("taskLabel1")
		if label:
			label.text = riddle_text
