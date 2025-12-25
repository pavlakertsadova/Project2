extends Sprite2D

const ANSWER_IDS := ["N", "E", "S", "W"]

@onready var pillar: Label = $Pillar
@onready var area: Area2D = $Area2D
@onready var interact_label: Label = $Label
@onready var blink_players := [
	$E/blinking_answers,
	$N/blinking_answers,
	$S/blinking_answers,
	$W/blinking_answers
]
@onready var answer_nodes := [
	get_parent().get_node("North"),
	get_parent().get_node("East"),
	get_parent().get_node("South"),
	get_parent().get_node("West")
]
@export var correct_answer := "W"

var blinking_started := false
var player_in_range := false
var texts = [
	"Press [E] to interact.",
	"Exactly one of the four is lying.\nThe liar's plate is safe to be pressed.\n [E] to continue",
	"North: South is telling the truth.\nSouth: East is telling the truth.\nEast: West is the right plate\nWest: North is lying",
	"To choose an answer stand on the plate and press [E]"
]
var texts_index = 0
var text_change = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	interact_label.visible = false
	pillar.visible = false
	for p in blink_players:
		p.stop()
		p.get_parent().visible = false
	for a in answer_nodes:
		a.plate_chosen.connect(_on_plate_chosen)

func _on_plate_chosen(chosen_name: String):
	if chosen_name == correct_answer:
		on_correct_answer(chosen_name)
	else:
		on_wrong_answer()

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
	if not blinking_started:
		for p in blink_players:
			p.get_parent().visible = true
			p.play("blink_answers")
		blinking_started = true
		return
	if texts_index < texts.size():
		interact_label.text = texts[texts_index]
	else:
		interact_label.visible = false
		text_change = false

func on_correct_answer(correct_id: String):
	for i in range(blink_players.size()):
		var letter: String = ANSWER_IDS[i]

		if letter == correct_id:
			blink_players[i].stop()
			blink_players[i].get_parent().visible = true
		else:
			blink_players[i].get_parent().visible = false
	pillar.visible = true
	show_label()
	print("PUZZLE SOLVED")

func show_label():
	pillar.modulate.a = 1.0
	var original_y = pillar.position.y
	
	var tween = create_tween().set_loops()
	tween.tween_property(pillar, "position:y", original_y - 5, 1.0)
	tween.tween_property(pillar, "position:y", original_y + 5, 1.0)

func on_wrong_answer():
	for p in blink_players:
		p.play("blinking_red")

	await get_tree().create_timer(0.25).timeout

	for p in blink_players:
		p.play("blink_answers")

	print("Try again")
