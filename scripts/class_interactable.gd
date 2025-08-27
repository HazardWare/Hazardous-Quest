class_name Interactable
extends Area2D

signal onPowerStateChanged
signal onTouchingPlayer

@export var locked : bool
@export var powered : bool



func trigger():
	print("What's up gang")
