extends Sprite2D

@export var is_correct_plate := true
@onready var area: Area2D = $Area2D
@export var plate_id := "W"

signal plate_chosen(plate_id: String)

var player_on_plate := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is Player:
		player_on_plate = true

func _on_body_exited(body):
	if body is Player:
		player_on_plate = false

func _input(event):
	if player_on_plate and event.is_action_pressed("interact"):
		emit_signal("plate_chosen", plate_id)
		interact()

func interact():
	if is_correct_plate:
		print("!!! ВЕРЕН ОТГОВОР (Западен паметник) !!!")
		
		# 1. Казваме на Глобалния скрипт, че Пъзел 1 е готов
		Global.level_progress["puzzle1"] = true
		Global.last_solved_puzzle = "puzzle1"
		
		# 2. Запазваме файла, за да може GameManager да го прочете
		Global.save_game()
		
		# 3. (Опционално) Връщаме се в лабиринта веднага
		# Ако искаш да има малка пауза или звук, сложи го преди този ред
		call_deferred("go_home")
		
	else:
		print("Грешен паметник. Нищо не се случва.")

# Добави тази помощна функция най-долу, за да се върнеш
func go_home():
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")
