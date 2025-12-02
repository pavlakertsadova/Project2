extends Sprite2D

@onready var area: Area2D = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		_enter_level()

func _enter_level():
	var new_scene = load("res://scenes/puzzle5.tscn")
	get_tree().change_scene_to_packed(new_scene)
