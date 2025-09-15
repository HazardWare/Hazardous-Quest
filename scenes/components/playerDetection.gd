extends RayCast2D

@onready var playerReference : Character = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	target_position = to_local(playerReference.global_position)
	if get_collider() == playerReference:
		get_parent().canSeePlayer = true
		$"../LastSeenPosition".global_position = playerReference.global_position
	else:
		get_parent().canSeePlayer = false
