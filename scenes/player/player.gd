extends Character

@export var validSwordAngleStep = 15.0

func _physics_process(delta: float) -> void:
	
	# Can't do this stuff whilst attacking
	if not $Arm/Attack.is_playing():
		# Handle movement
		var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
		velocity = direction * speed * delta
	
		# Rotate the sword toward the mouse
		var angleToTheMouse = get_global_mouse_position().angle_to_point(position)
		$Arm.rotation = deg_to_rad( snapped( rad_to_deg(angleToTheMouse) + 180 , validSwordAngleStep) )
	else:
		velocity = Vector2.ZERO
		
	# Debug:
	if Input.is_action_just_pressed("ui_accept"):
		$Arm/Attack.play("jab")


	move_and_slide()
