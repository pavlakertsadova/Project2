class_name WeightPlate
extends Node2D

@export var required_id: String = "Statue"
@onready var area: Area2D = $Area2D

var current_object: WeightObject = null
signal plate_changed

func _ready():
	add_to_group("weight_plates")  # ✨ Добави плочата в група
	print("🟦 Плоча добавена в група:", name)  # ✨ debug
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	var obj: Node2D = _find_weight_object(body)
	if obj and not obj.is_carried:
		current_object = obj
		print("✅ Плочата прие (body_entered):", obj.object_id)
		emit_signal("plate_changed")
	else:
		print("❌ Това не е WeightObject или се носи:", body)

func _on_body_exited(body):
	var obj: Node2D = _find_weight_object(body)
	if obj == current_object:
		current_object = null
		print("⬅️ Плочата се освободи")
		emit_signal("plate_changed")

# ✨ НОВО: форсирана проверка за обект
func force_check_object(obj: WeightObject):
	if obj and not obj.is_carried:
		current_object = obj
		print("✅ Плочата прие (force_check):", obj.object_id)
		emit_signal("plate_changed")
		
func force_remove_object(obj: WeightObject):
	if obj == current_object:
		current_object = null
		print("⬅️ Плочата се освободи (force_remove)")
		emit_signal("plate_changed")

func is_correct() -> bool:
	return current_object != null and current_object.object_id == required_id

func _find_weight_object(node: Node) -> WeightObject:
	var current := node
	while current:
		if current is WeightObject:
			return current
		current = current.get_parent()
	return null
