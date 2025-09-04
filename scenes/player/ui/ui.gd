extends Control

func update_health(player : Character):
	
	# Clear children
	for child in $HealthBar.get_children():
		child.queue_free()

	# Red health
	var maxHearts := int(ceil(player.maximumHealth / 2.0))
	var fullHearts := player.redHealth / 2
	var hasHalfHeart := player.redHealth % 2 == 1

	for i in (maxHearts):
		var this_heart : Heart = Heart.new()

		if i < fullHearts:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.FULL, false)
		elif i == fullHearts and hasHalfHeart:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.HALF, false)
		else:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.EMPTY, false)

		$HealthBar.add_child(this_heart)

	# Blue health
	var blueHearts := int(ceil(player.blueHealth / 2.0))
	var fullBlueHearts := player.blueHealth / 2
	var hasHalfBlue := player.blueHealth % 2 == 1

	for i in (blueHearts):
		var this_heart : Heart = Heart.new()

		if i < fullBlueHearts:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.FULL, true)
		elif i == fullBlueHearts and hasHalfBlue:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.HALF, true)
		else:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.EMPTY, true)

		$HealthBar.add_child(this_heart)
