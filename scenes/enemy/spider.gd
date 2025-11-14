extends Enemy

var direction : Vector2



func _ready() -> void:
	super()
	jump()

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	updateHealth()
	$CollisionShape2D.position = $AnimatedSprite2D.position
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move(delta)
	continousDamage(delta)

	

func jump():
	direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	$AnimationPlayer.play("jump")
	await !moving
	$WalkTimer.start(1)

func move(delta):
	if moving:
		velocity = speed * direction * delta
		print(velocity)
		move_and_slide()
		handlePush()

func _on_walk_timer_timeout() -> void:
	jump()

func calculateDirection() -> void:
	var x1
	var x2
	var y1
	var y2
	
	var xDif = playerReference.global_position.x - global_position.x
	var yDif = playerReference.global_position.y - global_position.y
	
	if xDif > (get_viewport_rect().size.x - 160):
		pass
	elif xDif > (get_viewport_rect().size.x - 160):
		pass
