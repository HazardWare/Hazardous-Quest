class_name Interactable
extends Area2D

signal onPowerStateChanged
signal onTouchingPlayer

@export var locked : bool
@export var powered : bool



func trigger():
	print("I'm interacting it so good!!!")
