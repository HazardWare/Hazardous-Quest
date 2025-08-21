extends Character

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed * delta
	move_and_slide()
	
	# Debug:
	if Input.is_action_just_pressed("ui_accept"):
		health += 1
