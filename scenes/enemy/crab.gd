extends Enemy

var direction := 1.0



func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move(delta)
	continousDamage(delta)

func move(delta):
	velocity.x = direction * speed * delta
	move_and_slide()
	handlePush()

func _on_left_boundary_area_entered(area: Area2D) -> void:
	direction = 1

func _on_right_boundary_area_entered(area: Area2D) -> void:
	direction = -1
