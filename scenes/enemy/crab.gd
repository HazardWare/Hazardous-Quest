extends Enemy

var direction := -1.0



func _ready() -> void:
	super()
	$RightBoundary.body_entered.connect(_on_right)
	$LeftBoundary.body_entered.connect(_on_left)
	

func _physics_process(delta: float) -> void:
	#print(direction)
	characterProcess(delta)
	
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move(delta)
	continousDamage(delta)

func move(delta):
	velocity.x = direction * speed * delta * 100
	move_and_slide()
	handlePush()

func _on_left(_body) -> void:
	direction = 1

func _on_right(_body) -> void:
	direction = -1
