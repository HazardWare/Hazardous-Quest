extends CharacterBody2D

@export var move_speed : float = 1500.0



func _physics_process(delta: float) -> void:
	# WALKING
	var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	velocity = direction * move_speed * delta
	move_and_slide()
