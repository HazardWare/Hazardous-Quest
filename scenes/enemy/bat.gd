extends Enemy

@export var moving := false



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

func move(delta):
	if moving:
		move_to(get_tree().get_first_node_in_group("Player").position, delta)
	else:
		velocity = Vector2.ZERO

func _on_fly_time_timeout() -> void:
	if moving:
		moving = false
		fly()
	else:
		moving = true
		fly()
