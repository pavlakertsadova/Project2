class_name WeightObject
extends Node2D

@export var object_id: String = ""
@onready var collision := $StaticBody2D/CollisionShape2D
@onready var area := $Area2D

var is_carried := false
var world_parent: Node = null   # ⬅️ къде да се връща

func _ready():
	world_parent = get_parent()
	# Свържи сигналите на Area2D на обекта
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)

func _on_area_entered(other_area):
	# Когато Area2D на обекта влезе в Area2D на плоча
	var plate = other_area.get_parent()
	if plate is WeightPlate and not is_carried:
		print("🎯 Обектът влезе в плоча:", plate.name, " | object_id:", object_id)
		plate.force_check_object(self)

func _on_area_exited(other_area):
	# Когато излезе от плочата
	var plate = other_area.get_parent()
	if plate is WeightPlate and not is_carried:  # ✨ Добави проверка
		print("⬅️ Обектът излезе от плоча:", plate.name)
		plate.force_remove_object(self)

func set_carried(value: bool, new_parent: Node = null):
	is_carried = value
	if value:
		# вдигане
		collision.disabled = true
		reparent(new_parent)
		position = Vector2.ZERO
	else:
		# пускане
		reparent(world_parent)
		# ✨ Изчакай един frame преди да включиш колизията
		await get_tree().process_frame
		collision.disabled = false
		# ✨ След това провери за плочи
		await get_tree().process_frame

func check_plates():
	# Намери всички плочи в сцената
	var plates = get_tree().get_nodes_in_group("weight_plates")
	print("🔍 Намерени плочи:", plates.size())  # ✨ debug
	for plate in plates:
		if plate is WeightPlate:
			# Провери дали се припокриваме с тази плоча
			var overlaps = plate.area.overlaps_body($StaticBody2D)
			print("  Проверка с плоча:", plate.name, "→ припокрива се:", overlaps)  # ✨ debug
			if overlaps:
				plate.force_check_object(self)
				print("🔍 Намерена плоча след пускане!")
				break
