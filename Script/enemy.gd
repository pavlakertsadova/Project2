extends CharacterBody2D

const SPEED = 50.0
var direction: int = 1
var last_direction := Vector2(1, 0)
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	velocity.x = direction * SPEED
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		direction *= -1
	
	if velocity.length() > 0:
		last_direction = Vector2(direction, 0)
		play_walk_animation()
	else:
		play_default_animation()

func _on_body_entered(body):
	if body.name == "player" or body.is_in_group("player"):
		reset_game()

func reset_game():
	get_tree().reload_current_scene()

func play_walk_animation():
	if direction > 0:
		animated_sprite_2d.play("default_right")
	elif direction < 0:
		animated_sprite_2d.play("default_left")

func play_default_animation():
	if last_direction.x > 0:
		animated_sprite_2d.play("default_right")
	elif last_direction.x < 0:
		animated_sprite_2d.play("default_left")
