extends Enemy

@export var moving := false



func _ready() -> void:
	super()
	jump()

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	$CollisionShape2D.position = $AnimatedSprite2D.position
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move(delta)
	continousDamage(delta)

func jump():
	$AnimationPlayer.play("jump")
	await !moving
	$WalkTimer.start(1)

func move(delta):
	if moving:
		if !navAgent.is_target_reached():
			move_to(navAgent.get_next_path_position(), delta)
		else:
			velocity = Vector2.ZERO
		move_and_slide()
		handlePush()

func _on_walk_timer_timeout() -> void:
	jump()
