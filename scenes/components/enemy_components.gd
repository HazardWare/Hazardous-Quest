extends Node2D
var canSeePlayer : bool:
	get:
		return canSeePlayer
	set(value):
		if value != canSeePlayer:
			print(value)
		canSeePlayer = value
