extends CharacterBody2D
class_name Player

const SPEED = 300.0
var last_direction := Vector2(1,0)
var input = Vector2.ZERO
var direction
var can_move = true
enum Direction {NONE, UP, DOWN, RIGHT, LEFT}
var facing_direction = Direction.NONE

@onready var light: PointLight2D = $PointLight2D

@onready var pickup_area: Area2D = $PickupArea2D
var carried_object: WeightObject = null
var nearby_object: WeightObject = null
@onready var carry_point = $CarryPoint

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _ready():
	add_to_group("player")  # Добавяме играча в група "player"
	print("Играчът е зареден и добавен в група 'player'")
	pickup_area.body_entered.connect(_on_pickup_body_entered)
	pickup_area.body_exited.connect(_on_pickup_body_exited)
	facing_direction = Direction.DOWN
	update_carry_point()
	light.enabled = false

func _physics_process(_delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction.length() > 0.1:
		velocity = direction * SPEED
		last_direction = direction
		update_facing_direction(direction)
		play_walk_animation()
	else:
		velocity = Vector2.ZERO
		play_default_animation()

	move_and_slide()
	update_carry_point()

func _input(event):
	if event.is_action_pressed("pick_up"):
		handle_pickup()

func handle_pickup():
	# ако носим нещо → пускаме
	if carried_object:
		drop_object()
		return

	# ако не носим и има обект наблизо → взимаме
	if nearby_object:
		pick_object(nearby_object)

func pick_object(obj: WeightObject):
	carried_object = obj
	obj.set_carried(true, $CarryPoint)

func drop_object():
	var obj = carried_object
	carried_object = null

	obj.set_carried(false)
	obj.global_position = global_position + last_direction * 16

	nearby_object = null

func update_facing_direction(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		facing_direction = Direction.RIGHT if dir.x > 0 else Direction.LEFT
	else:
		facing_direction = Direction.DOWN if dir.y > 0 else Direction.UP

func update_carry_point():
	match facing_direction:
		Direction.RIGHT:
			$CarryPoint.position = Vector2(16, 0)
		Direction.LEFT:
			$CarryPoint.position = Vector2(-16, 0)
		Direction.UP:
			$CarryPoint.position = Vector2(0, -16)
		Direction.DOWN:
			$CarryPoint.position = Vector2(0, 16)

func play_walk_animation():
	if direction.x > 0:
		$AnimatedSprite2D.play("right")
		facing_direction = Direction.RIGHT
	elif direction.x < 0:
		$AnimatedSprite2D.play("left")
		facing_direction = Direction.LEFT
	elif direction.y > 0:
		$AnimatedSprite2D.play("down")
		facing_direction = Direction.DOWN
	elif direction.y < 0:
		$AnimatedSprite2D.play("up")
		facing_direction = Direction.UP

func play_default_animation():
	if facing_direction == Direction.RIGHT:
		$AnimatedSprite2D.play("default_right")
	elif facing_direction == Direction.LEFT:
		$AnimatedSprite2D.play("default_left")
	elif facing_direction == Direction.DOWN:
		$AnimatedSprite2D.play("default_down")
	elif facing_direction == Direction.UP:
		$AnimatedSprite2D.play("default_up")
		
func _on_pickup_body_entered(area):
	var obj = area.get_parent()
	if obj is WeightObject and not obj.is_carried:
		nearby_object = obj
		print("🟢 Може да се вдигне:", obj.object_id)
		
func _on_pickup_body_exited(area):
	if area.get_parent() == nearby_object:
		nearby_object = null

func _set_light_enable(value: bool):
	light.enabled = value
