@icon("res://assets/icons/icon_call.png")
class_name Interactable
extends Area2D
## Things that can be interacted with in the world.

signal onPowerStateChanged

@export var toggleable : bool = false

@export var initial_locked := false ## Does this start locked?
@export var initial_powered := false ## Does this start powered?

@export_flags_2d_navigation var interacts_with

@onready var locked := initial_locked 
@onready var powered := initial_powered :
	set( new ):
		if ( new != powered ):
			onPowerStateChanged.emit()
		powered = new

var playerReference: Character:
	get:
		return get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	body_entered.connect(_body_entered_interactable)

func trigger():
	powered = !powered

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and overlaps_body(playerReference):
		trigger()

func _body_entered_interactable():
	print("Hello")
