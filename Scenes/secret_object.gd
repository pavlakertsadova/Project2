extends Area2D

func _on_body_entered(body):
	# Реагираме само ако е видим и е играч
	if visible and body.is_in_group("player"):
		# Казваме на главния скрипт (Puzzle5)
		owner.finish_puzzle()
