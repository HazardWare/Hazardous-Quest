extends Enemy



func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	characterProcess(delta)
	
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	move_to(get_tree().get_first_node_in_group("Player").position, delta)
	continousDamage(delta)
	move_and_slide()
	handlePush()

func _on_enemy_hit() -> void:
	## Hides enemy and health bar
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.TRANSPARENT, 0.5)
	$EnemyComponents.visible = false
	$HurtBox/CollisionShape2D.set_deferred(disabled, true)
	$InvisTimer.start(1)
	acceleration = .25

func _on_invis_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	position = Vector2(position.x + randf_range(-500, 500), position.y + randf_range(-500, 500))
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.5)
	$EnemyComponents.visible = true
	$HurtBox/CollisionShape2D.disabled = false
	acceleration = 5

func go_to_player():
	pass
