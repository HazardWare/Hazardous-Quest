extends Character

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	velocity = direction * speed * delta
	move_and_slide()
	
	$Arm.look_at(get_global_mouse_position())
	
	# Debug:
	if Input.is_action_just_pressed("ui_accept"):
		health += 1
