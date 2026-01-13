extends Sprite2D
class_name SpecialColumn

signal column_touched(column: SpecialColumn)

@export var active := false

var timer := 0.0
var on := false
@onready var area: Area2D = $Area2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	_apply_visual()

func set_active(value: bool) -> void:
	active = value
	timer = 0.0
	on = false
	_apply_visual()

func _process(delta: float) -> void:
	if not active:
		return

	timer += delta
	if timer >= 0.6: # скорост на пулса (пример)
		timer = 0.0
		on = !on
		_apply_visual()

func _apply_visual() -> void:
	if not active:
		modulate = Color(1, 1, 1, 1)
	else:
		modulate = Color(1, 1, 1, 1) if not on else Color(0.92, 0.92, 0.92, 1)

func _on_body_entered(body: Node) -> void:
	if not active:
		return
	if not body.is_in_group("player"):
		return

	column_touched.emit(self)
