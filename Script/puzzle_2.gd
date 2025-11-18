
extends Node2D
# В горната част на всеки puzzle скрипт добави:
signal puzzle_solved
signal puzzle_closed

# И в частта за верен отговор:
func check_answer():
	# ... твоя код за проверка ...
	#if правилен_отговор:
		# ...
		puzzle_solved.emit()
		queue_free()

# И за бутона за затваряне:
func _on_close_pressed():
	puzzle_closed.emit()
	queue_free()
