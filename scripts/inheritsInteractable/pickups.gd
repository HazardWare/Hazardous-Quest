class_name Pickups
extends Interactable

@export var add_inventory: bool
#If true, then it adds itself to the inventory. If false, adds itself to a variable of choice
@export var variable: String
#Variable name, MUST BE IN GLOBAL (If add_inventory = false)
@export var worth: float
#"How much" you get from picking up (If add_inventory = false)



func _process(delta: float) -> void:
	super(delta)
	if touchingPlayer:
		if add_inventory:
			Global.inventory.push_back(self.name)
		else:
			addToVariable(variable, worth)
		queue_free()

func addToVariable(zVariable, zWorth):
	Global[zVariable] += zWorth
	
