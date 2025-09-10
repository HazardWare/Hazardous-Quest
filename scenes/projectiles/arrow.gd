extends Projectile

var already_dropped = false


func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	
	if !stabbed:
		# Move forward based on rotation.
		velocity = initial_velocity + (transform.x * speed)
	else:
		if get_parent() is Enemy:
			look_at(get_parent().position)
		return
		
	if velocity:
			sprite.global_rotation = deg_to_rad(45.0) + velocity.angle()
			collisionShape.global_rotation = sprite.global_rotation
	move_and_slide()

func on_touch_body(body: Node2D):
	if self.is_in_group("friendly"):
		if !body.is_in_group("friendly") and not stabbed:
			#queue_free()
			
			collisionShape.set_deferred("disabled", true)
		
			self.velocity = Vector2.ZERO
			if body is Enemy && !stabbed:
				body.health -= strength
				body.applyKnockback((body.global_position - self.global_position).normalized(), 250.0, 0.12)
				show_behind_parent = true
			stabbed = true
			strength = 0
			$Hit.play()
			
			self.modulate = Color(1,1,1,0.6)
			call_deferred("reparent", body)
			
			if(body is TileMapLayer and not already_dropped):
				already_dropped = true
	pass
