extends Enemy



func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move_to(Vector2(get_tree().get_first_node_in_group("Player").position.x, global_position.y), delta)
	continousDamage(delta)
	move_and_slide()
	handlePush()
	
