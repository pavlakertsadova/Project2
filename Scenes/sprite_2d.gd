extends Sprite2D

@onready var area: Area2D = $Area2D
var player_in_range := false

func _ready():
	print("Вратата е заредена успешно!")
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("Сблъсък открит с: ", body.name)
	# Променяме проверката да работи с името или групата
	if body.name == "player" or body.is_in_group("player"):
		player_in_range = true
		print("Играчът приближи вратата")

func _on_body_exited(body):
	print("Изход от зоната: ", body.name)
	if body.name == "player" or body.is_in_group("player"):
		player_in_range = false
		print("Играчът се отдалечи от вратата")

func _input(event):
	if player_in_range and event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			print("Натиснато E за взаимодействие")
			interact()

func interact():
	print("Преминаване към puzzle1 сцената")
	get_tree().change_scene_to_file("res://Scenes/puzzle1.tscn")
