extends Node2D

@onready var area: Area2D = $Area2D
@onready var finish_label: Label = $"../Label/Finish"

var active := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.monitoring = false   # ⛔ първоначално изключен
	finish_label.visible = false

func set_active(value: bool):
	active = value
	area.monitoring = value
	print("Exit active:", value)
	finish_label.visible = true
	show_label()

func show_label():
	finish_label.modulate.a = 1.0
	var original_y = finish_label.position.y
	
	var tween = create_tween().set_loops()
	tween.tween_property(finish_label, "position:y", original_y - 5, 1.0)
	tween.tween_property(finish_label, "position:y", original_y + 5, 1.0)

func _on_body_entered(body):
	if not active:
		return

	if body.is_in_group("player"):
		print("➡️ ИЗХОД!")
		get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
