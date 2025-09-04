extends Character

@export var validSwordAngleStep := 90.0 ## Angle the sword will snap to.

@export_subgroup ("Inventory")
@export_enum("Without:0", "One:1", "Two:2", "Magic:3") var swordLevel : int
@export var hasBangarang := false
@export var hasBow := false
@export var hasShield := false
@export var hasCandle := false
@export var grenades := 0


var hitbox_touching : bool = false
var area_touching : Area2D

func _physics_process(delta: float) -> void:
	
	
	#Looking nice stuff
	if velocity.length() > 0 and not $Arm/Attack.is_playing():
		$AnimationPlayer.play('walk')
		if (velocity.x < 0):
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false 
	else:
		$AnimationPlayer.play("RESET")
	
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
		
	# Jab:
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("RESET")
		$Arm/Attack.play("jab")
		
		var lookingLeft = snapped( rad_to_deg(get_global_mouse_position().angle_to_point(position)) + 180 , 180) == 180
		$AnimatedSprite2D.flip_h = lookingLeft
		
	move_and_slide()
	
	
	if hitbox_touching and area_touching is Lever and Input.is_action_just_pressed("interact"):
		area_touching.trigger()

# For interactable detection
func _on_hit_box_area_entered(area: Area2D) -> void:
	hitbox_touching = true
	area_touching = area

func _on_hit_box_area_exited(area: Area2D) -> void:
	hitbox_touching = false
