extends Enemy

var newPos := Vector2.ZERO



func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	super(delta)

func _on_enemy_hit() -> void:
	## Hides enemy and health bar
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.TRANSPARENT, 0.5)
	$EnemyComponents.visible = false
	$HurtBox/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$InvisTimer.start(1)
	newPos = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	acceleration = 1

func _on_invis_timer_timeout() -> void:
	## Wait for not collide
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.5)
	$EnemyComponents.visible = true
	$HurtBox/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = true
	acceleration = 5
