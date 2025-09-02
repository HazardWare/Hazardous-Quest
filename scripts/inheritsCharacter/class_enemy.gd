@icon("res://assets/icons/icon_skull.png")
class_name Enemy
extends Character

signal onDetectPlayer

@export var randomDrop := false ## Tick this to make item drops random, keep it un-ticked for a specific item drop
@export_enum("Money", "Health") var Drops : String ## Item that the enemy drops. Ignore this if randomDrop is ticked
@export var overworldEnemy := true

enum DetectionSystems {MANUAL, LINE_OF_SIGHT, DAMAGE}
@export var PlayerDetectionSystem := DetectionSystems.LINE_OF_SIGHT

@export_subgroup("Linked nodes")
@export var navAgent : NavigationAgent2D
@export var rayCast : RayCast2D
@export_subgroup("")
var detectsPlayer := false
var lastSeenPlayerPosition : Vector2
var spawnerNode : Node2D

#region Godot Functions:

#endregion
#region Custom Methods:
func makePath():
	navAgent.target_position = lastSeenPlayerPosition
#endregion
#region Signal:

#endregion
