extends Area2D

var player_is_close = false

# 1. Засичаме кога героят е до предмета
func _on_body_entered(body):
	if body.name == "Player":
		player_is_close = true

# 2. Засичаме кога се отдалечава (за да не се активира от далече)
func _on_body_exited(body):
	if body.name == "Player":
		player_is_close = false

# 3. Слушаме за натискане на бутон (SPACE или ENTER)
func _process(delta):
	if player_is_close and Input.is_action_just_pressed("ui_accept"):
		print("ГРЕШКА! Това е капан.")
		
		# Този ред рестартира нивото веднага
		get_tree().reload_current_scene()
