extends Enemy



func _ready() -> void:
	super()
	fly()

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	
	move_and_slide()
	handlePush()
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move(delta)
	continousDamage(delta)
	

func fly():
	$FlyTime.start(1)



func _on_fly_time_timeout() -> void:
	print
	if moving:
		moving = false
		fly()
	else:
		moving = true
		fly()
