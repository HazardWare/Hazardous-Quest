extends Interactable

func _process(_delta: float) -> void:
	super(_delta)
	print(Global.inventory.bsearch("Key", true))
