extends Enemy

func _ready() -> void:
	super()
	strength += randi_range(0, 2)
	speed += randf_range(-25.0, 100.0)
	friction += randf_range(-4.0, 4.0)
	acceleration += randf_range(-4.5, 5.0)
	maximumHealth += randi_range(-5, 5)
