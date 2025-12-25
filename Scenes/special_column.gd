extends Sprite2D

var timer := 0.0
var on := false
@onready var area: Area2D = $Area2D

func _process(delta: float) -> void:
	timer += delta
	if timer >= 2.0:
		timer = 0.0
		on = !on
		modulate = Color(1,1,1,1) if not on else Color(0.9,0.9,0.9,1)
signal column_touched

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		column_touched.emit()
