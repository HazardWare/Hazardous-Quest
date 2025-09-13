extends Enemy

var direction := -1.0
var latched := false


func _ready() -> void:
	super()
	$RightBoundary.body_entered.connect(_on_right)
	$LeftBoundary.body_entered.connect(_on_left)
	hurtBox.area_entered.connect(latch)

func _physics_process(delta: float) -> void:
	#print(direction)
	characterProcess(delta)
	updateHealth()
	
	if latched:
		playerReference.global_position = global_position
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move(delta)
	continousDamage(delta)

func move(delta):
	velocity.x = direction * speed * delta * 100
	move_and_slide()
	handlePush()

func latch(area: Area2D):
	if area.get_parent() == playerReference:
		latched = true
	pass

func _on_left(_body) -> void:
	direction = 1

func _on_right(_body) -> void:
	direction = -1
