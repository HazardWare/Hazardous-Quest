@icon("res://assets/icons/icon_call.png")
class_name Interactable
extends Area2D
## Things that can be interacted with in the world.

signal onPowerStateChanged

@export var initial_locked := false ## Does this start locked?
@export var initial_powered := false ## Does this start powered?

@export_flags_2d_navigation var interacts_with

@onready var locked := initial_locked 
@onready var powered := initial_powered :
	set( new ):
		if ( new != powered ):
			onPowerStateChanged.emit()
		powered = new



func trigger():
	powered = !powered
