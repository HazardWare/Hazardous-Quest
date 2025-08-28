class_name Interactable
extends Area2D

signal onPowerStateChanged
signal onTouchingPlayer

# Adds dropdown in editor for whether or not you want the interactable to be powered or locked by default
@export_enum("true", "false") var initial_locked : String
@export_enum("true", "false") var initial_powered : String

var locked : bool
var powered : bool



func _ready() -> void:
	# Sets the powered and locked properties upon initializing
	if initial_powered == "true":
		powered = true
	else:
		powered = false

	if initial_locked == "true":
		locked = true
	else:
		locked = false

func trigger() -> void:
	#For when the player interacts with the interactables
	print("I'm interacting it so good!!!")
