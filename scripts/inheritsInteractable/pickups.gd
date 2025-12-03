class_name Pickups
extends Interactable



func _process(delta: float) -> void:
	super(delta)
	if touchingPlayer:
		Inventory.inventory.push_back(self.name)
		queue_free()
	
