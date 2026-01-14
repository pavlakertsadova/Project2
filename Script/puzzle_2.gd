
extends Node2D
# В горната част на всеки puzzle скрипт добави:
signal puzzle_solved
signal puzzle_closed
var is_near_barrel = false
var is_near_vase = false

func _ready():
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)
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
	


func _on_barrel_trigger_body_entered(body: Node2D) -> void:
	if body.name == "player": # Проверяваме дали е Героя
		print("Стъпи на мина! (Бъчва)")
		get_tree().reload_current_scene() # Веднага рестарт

func _on_vase_trigger_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("Стъпи на мина! (Ваза)")
		get_tree().reload_current_scene() # Веднага рестарт
# --- ВАЗАТА (VASE) ---
func _on_barrel_trigger_body_exited(body: Node2D) -> void:
	pass

func _on_vase_trigger_body_exited(body: Node2D) -> void:
	pass
