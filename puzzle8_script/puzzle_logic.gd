extends Node2D

@onready var levers = get_node("../Levers").get_children()
@onready var symbols = get_node("../Symbols")
@onready var chest = get_parent().get_node("Chest")

var stage := 0
var unlocked := {
	"C": false,
	"H": false,
	"E": false,
	"S": false,
	"T": false
}
var lever_states := {
	"A": false,
	"B": false,
	"C": false
}

func _ready():
	print("CHEST NODE =", chest)
	for lever in levers:
		lever.lever_toggled.connect(_on_lever_toggled)
	AudioManager.set_mode(AudioManager.MusicMode.PUZZLE)

	update_symbols()
	
func _on_lever_toggled(id: String, is_on: bool):
	lever_states[id] = is_on
	
	update_symbols()
	
func update_symbols() -> void:
	var A = lever_states["A"]
	var B = lever_states["B"]
	var C = lever_states["C"]

	# -------- ЕТАП 1 --------
	if stage == 0:
		if A and not B and C:
			unlock_symbol("E")
			stage = 1
			await get_tree().create_timer(0.4).timeout
			reset_levers()

	# -------- ЕТАП 2 --------
	elif stage == 1:
		if not A and B and C:
			unlock_symbol("C")
			unlock_symbol("S")
			stage = 2
			await get_tree().create_timer(0.4).timeout
			reset_levers()

	# -------- ЕТАП 3 --------
	elif stage == 2:
		if A and B and not C:
			unlock_symbol("H")
			unlock_symbol("T")
			stage = 3
			await get_tree().create_timer(0.4).timeout
			reset_levers()
			
			chest.set_active(true)
			print("PUZZLE SOLVED")

func reset_levers():
	for lever in levers:
		lever.force_off()
		lever_states[lever.lever_id] = false

func unlock_symbol(letter: String):
	if unlocked[letter]:
		return  # вече е отключена → нищо не правим

	unlocked[letter] = true

	var label = symbols.get_node(letter)
	var anim = label.get_node("AnimationPlayer")
	anim.play("glow")
