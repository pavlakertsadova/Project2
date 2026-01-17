extends Sprite2D

@onready var area: Area2D = $Area2D
var exited := false

@onready var sfx_door: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if exited:
		return
	# Увери се, че проверката за играча работи (може да ползваш и is_in_group("player"))
	if body.name == "player" or body.is_in_group("player") or (body.get_script() and body is Player):
		
		# Проверяваме дали загадката е решена (от другата променлива)
		if Puzzle1Answer.puzzle_solved:
			print("ИЗЛИЗАНЕ: Загадката е решена. Записвам и излизам.")
			exited = true
			area.monitoring = false
			
			# 1. Обновяваме глобалните данни
			Global.level_progress["puzzle1"] = true
			Global.last_solved_puzzle = "puzzle1"
			Global.checkpoint_id = "Checkpoint_1"
			
			# 2. ВАЖНО: ЗАПИСВАМЕ ГИ ВЪВ ФАЙЛ!
			Global.save_game()
			sfx_door.play()
			call_deferred("_go_to_main_scene")

func _go_to_main_scene():
	await get_tree().process_frame
	# change_scene_to_file е по-лесно и директно от loading/packed
	get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")
