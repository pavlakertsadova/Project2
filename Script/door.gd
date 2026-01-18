extends Sprite2D

@onready var area: Area2D = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		area.monitoring = false
		call_deferred("_enter_level")

func _enter_level():
	get_tree().change_scene_to_file("res://Scenes/puzzle1.tscn")
