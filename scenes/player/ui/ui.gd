extends Control

func update_health(reds : int, blues : int):
	# I could probably make this better, but idk how.
	var reds_left : float = reds / 2
	for i in reds:
		if reds_left >= 0.5: # If there's a full heart
			var this_heart : Heart = Heart.new()
			this_heart.initiate_heart(false,false)
			$HealthBar.add_child(this_heart)
