extends Area2D

# Текстът на гатанката
var riddle_text = "Find this subject: I am a throne, yet not for kings, but for travelers.\nHeavy as stone, but my comfort is light.\nFind rest upon me, and the way shall open."

func _on_body_entered(body):
	# Проверяваме дали влязлото тяло е играчът
	if body.name == "player":
		# Търсим етикета вътре в героя
		var label = body.get_node_or_null("taskLabel1")
		if label:
			label.text = riddle_text
