extends CharacterBody2D
class_name Player

const SPEED = 100.0
var last_direction := Vector2(1,0)
var input = Vector2.ZERO
var direction
var can_move = true
enum Direction {NONE, UP, DOWN, RIGHT, LEFT}
var facing_direction = Direction.NONE

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if not can_move:  # <-- ДОБАВЕНО
		velocity = Vector2.ZERO
		return
	direction = Input.get_vector("move_left", "move_right","move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation()
	else:
		play_default_animation()
		
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
