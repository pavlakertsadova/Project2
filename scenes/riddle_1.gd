extends Sprite2D

@onready var area: Area2D = $Area2D
@onready var interact_label: Label = $Label

var player_in_range := false
var texts = [
	"Only the plate that faces the liar is safe to stand upon.",
	"North claims: I am the correct plate.
	 South claims: North is lying.
	 East claims: West is wrong.
	 West is silent."
]
var texts_index = 0
var text_change = false


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	interact_label.visible = false

func _on_body_entered(body):
	if body is Player:
		player_in_range = true
		interact_label.visible = true
		texts_index = 0
		interact_label.text = texts[texts_index]
		text_change = true

func _on_body_exited(body):
	if body is Player:
		player_in_range = false
		interact_label.visible = false
		text_change = false

func _input(event):
	if player_in_range and event.is_action_pressed("interact") and text_change:
		texts_index +=1
		interact()

func interact():
	print("Interacted with", name)
	if texts_index < texts.size():
		interact_label.text = texts[texts_index]
	else:
		interact_label.visible = false
		text_change = false	
