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
#@export var rayCast : RayCast2D

var detectsPlayer := false
var lastSeenPlayerPosition : Vector2
var spawnerNode : Node2D
@export var navInterval : Timer
@onready var rayCast : RayCast2D = RayCast2D.new()
@export var navAgent : NavigationAgent2D
@export var hurtBox : Area2D
@export_subgroup("")

#region Godot Functions:
func _ready() -> void:
	super()
	navInterval.autostart = true
	navInterval.wait_time = 0.1
	
	navInterval.start()
	navInterval.timeout.connect(makePath)
	
	hurtBox.area_entered.connect(damagePlayer)
	
func _physics_process(delta: float) -> void:
	
	move_to(navAgent.get_next_path_position(), delta)
	move_and_slide()
	handlePush()
	
#endregion
#region Custom Methods:
func makePath():
	navAgent.target_position = get_tree().get_first_node_in_group("Player").position
	

#endregion
#region Signal:



func damagePlayer(area : Area2D):
	var parent : Node = area.get_parent()
	if parent is Character:
		parent.health -= strength
