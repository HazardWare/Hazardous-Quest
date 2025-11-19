extends Enemy

var direction : Vector2



func _ready() -> void:
	super()
	jump()
	calculateDirection()
	

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	updateHealth()
	$CollisionShape2D.position = $AnimatedSprite2D.position
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
		
	move(delta)
	continousDamage(delta)

	

func jump():
	calculateDirection()
	$AnimationPlayer.play("jump")
	await !moving
	$WalkTimer.start(1)

func move(delta):
	if moving:
		velocity = speed * direction * delta
		move_and_slide()
		handlePush()

func _on_walk_timer_timeout() -> void:
	jump()

func calculateDirection() -> void:
	#Calculates how big one quarter of thr screen is (quadOut) and how big the "Safe Zone" is (quadIn) -A
	var xQuadOut : float = (get_viewport_rect().size.x / get_canvas_transform().x.x) / 2
	var xQuadIn : float = xQuadOut * 1/10
	var yQuadOut : float = (get_viewport_rect().size.y / get_canvas_transform().y.y) / 2
	var yQuadIn : float = yQuadOut * 0.2
	
	var quadIn : Vector2 = Vector2(xQuadIn, yQuadIn)
	var quadOut : Vector2 = Vector2(xQuadOut, yQuadOut)
	
	#Calculates Quadrant -A
	var dist : Vector2 = global_position - playerReference.global_position
	var quadrant : int
	
	if dist.x < 0 and dist.y < 0:
		quadrant = 1 
	elif dist.x > 0 and dist.y < 0:
		quadrant = 2
	elif dist.x < 0 and dist.y > 0:
		quadrant = 3
	elif dist.x > 0 and dist.y > 0:
		quadrant = 4
	else:
		return
	
	#Calculates whether the spider is in the "Safe Zone" -A
	var safe : bool
	if abs(dist) >= quadIn:
		safe = false
	else:
		safe = true
	
	#Calculated Direction
	if safe:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	else:
		if quadrant == 1:
			direction = Vector2(randf_range(0, 1), randf_range(0, 1))
		if quadrant == 2:
			direction = Vector2(randf_range(-1, 0), randf_range(0, 1))
		if quadrant == 3:
			direction = Vector2(randf_range(0, 1), randf_range(-1, 0))
		if quadrant == 4:
			direction = Vector2(randf_range(-1, 0), randf_range(-1, 0))
	
