extends Node

@export_group("Player Settings")
@export var player: Node2D

@export_group("Doors Configuration")
@export var closed_doors: Array[Node2D]
@export var open_doors: Array[Node2D]

@export_group("Spawn Positions")
@export var spawn_positions: Array[Vector2]

@onready var sfx_door: AudioStreamPlayer2D = $"../openDoors/AudioStreamPlayer2D"
var play_sfx_door := false

func _ready():
	Global.load_game()
	await get_tree().process_frame
	update_level()
	await get_tree().physics_frame
	set_player_spawn()
	AudioManager.set_mode(AudioManager.MusicMode.MAIN)

func update_level():
	# Скриваме всички отворени врати за безопасност
	for door in open_doors:
		if door: door.visible = false

	# Проверяваме Пъзели 1 до 9
	for i in range(1, 10): 
		var puzzle_key = "puzzle" + str(i)
		var index = i - 1 
		
		# Ако пъзелът е решен...
		if Global.level_progress.has(puzzle_key) and Global.level_progress[puzzle_key] == true:
			print("Отварям врата за: ", puzzle_key)
			
			# 1. Махаме затворената врата (Ако съществува)
			if index < closed_doors.size():
				var door = closed_doors[index]
				# Проверяваме is_instance_valid, за да не гръмне, ако вече е изтрита
				if is_instance_valid(door):
					door.queue_free() # ТВОЯТ СТАР МЕТОД
			
			# 2. Показваме отворената врата
			if index < open_doors.size():
				var door = open_doors[index]
				if is_instance_valid(door):
					door.visible = true

					if not play_sfx_door:
						sfx_door.play()
						play_sfx_door = true

func set_player_spawn():
	if Global.checkpoint_id == "" or player == null:
		return

	var cp = get_tree().current_scene.get_node_or_null(Global.checkpoint_id)
	if cp:
		player.global_position = cp.global_position
		print("SPAWN at checkpoint:", Global.checkpoint_id, cp.global_position)
	else:
		print("❌ Checkpoint not found:", Global.checkpoint_id)
