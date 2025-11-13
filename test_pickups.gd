extends Area2D

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered():
	pass
