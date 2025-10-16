extends Node2D
var canSeePlayer : bool = false:
	get:
		return canSeePlayer
	set(value):
		if value != canSeePlayer:
			print(value)
		canSeePlayer = value
