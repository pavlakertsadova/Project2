extends CharacterBody2D

const SPEED = 100.0
var last_direction := Vector2(1,0)
var input = Vector2.ZERO
var direction
var can_move = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSSprite2D

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
	elif direction.x < 0:
		$AnimatedSprite2D.play("left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("up")

func play_default_animation():
	if direction.x > 0:
		$AnimatedSprite2D.play("default_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("default_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("default_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("default_up")
