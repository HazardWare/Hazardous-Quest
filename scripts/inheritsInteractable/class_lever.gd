class_name Lever
extends Interactable
## Directly interactable objects which trigger other events.

@export var toggler := false 
@export var walkoverTrigger := false

func trigger():
	if toggler:
		powered = !powered
		# setting powered already emits 
	else:
		onPowerStateChanged.emit()
