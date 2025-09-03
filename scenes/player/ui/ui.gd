extends Control

func update_health(player : Character):
	for child in $HealthBar.get_children():
		child.queue_free()
		
	# I could probably make this better, but idk how.
	for i in player.maximumHealth:
		var this_heart : Heart = Heart.new()
		
		if i < player.redHealth:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.FULL,false)
		else:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.EMPTY,false)
		
		$HealthBar.add_child(this_heart)
		
	for i in player.blueHealth:
		var this_heart : Heart = Heart.new()
		
		if i < player.blueHealth:
			this_heart.initiate_heart(Heart.POSSIBLE_HEARTS.FULL,true)
		
		$HealthBar.add_child(this_heart)
