extends Node2D

@export var lever_id: String = "A"
@export var starts_on := false

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

@onready var lever_pull: AudioStreamPlayer2D = $"../../lever"

signal lever_toggled(id: String, is_on: bool)

var is_on := false
var player_in_range := false

func _ready():
	is_on = starts_on
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	label.visible = false

func _on_body_entered(body):
	if body is Player:
		player_in_range = true
		label.visible = true

func _on_body_exited(body):
	if body is Player:
		player_in_range = false
		label.visible = false

func _unhandled_input(event):
	if player_in_range and event.is_action_pressed("interact"):
		toggle()

func toggle():
	is_on = !is_on
	sprite.flip_v = is_on
	lever_pull.play()
	emit_signal("lever_toggled", lever_id, is_on)
	print("Lever", lever_id, "=", is_on)
	
func force_off():
	is_on = false
	sprite.flip_v = is_on
	lever_pull.play()
