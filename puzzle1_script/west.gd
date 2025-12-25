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
	pass
	if is_correct_plate:
		print(">>> Correct plate chosen!")
	else:
		print("Wrong plate (but doing nothing).")
