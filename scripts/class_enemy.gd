class_name Enemy
extends Character

signal onDetectPlayer

@export var randomDrop := false ## Tick this to make item drops random, keep it un-ticked for a specific item drop
@export_enum("Money", "Health") var Drops : String ## Item that the enemy drops. Ignore this if randomDrop is ticked

@export var overworldEnemy := true

var detectsPlayer := false
var spawnerNode
enum DetectionSystems {MANUAL, LINE_OF_SIGHT, DAMAGE}
@export var PlayerDetectionSystem : DetectionSystems = DetectionSystems.MANUAL


func _physics_process(delta: float) -> void:
	pass
