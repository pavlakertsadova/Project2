extends Node2D

@export var next_scene := "res://Scenes/node_2d.tscn"

@onready var area := $Area2D

@onready var answer_chest: AudioStreamPlayer2D = $"../rightAnswer"

var active := false

func _ready():
	area.body_entered.connect(_on_body_entered)

func set_active(value: bool):
	answer_chest.play()
	active = value
	print("Chest active =", active)
	

func _on_body_entered(body):
	if body is Player and active:
		Global.level_progress["puzzle8"] = true
		Global.last_solved_puzzle = "puzzle8"
		Global.checkpoint_id = "Checkpoint_8"
		Global.save_game()
		get_tree().change_scene_to_file(next_scene)
