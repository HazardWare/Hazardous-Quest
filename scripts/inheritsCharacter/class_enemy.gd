@icon("res://assets/icons/icon_skull.png")
class_name Enemy
extends Character

signal enemy_hit

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
#@onready var floorTilemap :TileMapLayer = get_tree().get_nodes_in_group("Tilemap")[0]
#@onready var obstacles :TileMapLayer = get_tree().get_nodes_in_group("Tilemap")[1]

var enemyComponent = preload("res://scenes/components/EnemyComponents.tscn")

#region Godot Functions:
func _ready() -> void:
	super()
	add_child(enemyComponent.instantiate())
	$EnemyComponents/StallTimer.start()
	
	navInterval.autostart = true
	navInterval.wait_time = 0.1
	
	navInterval.start()
	navInterval.timeout.connect(makePath)
	
	hurtBox.area_entered.connect(areaEntered)
	
	$EnemyComponents/Spawn.play()
	
	#self.onDamaged.connect(func(d):print(health))
	
func _physics_process(delta: float) -> void:
	super(delta)
	
	updateHealth()
	
	if $EnemyComponents/StallTimer.time_left != 0.0:
		return
	
	basicMoving(delta)
	continousDamage(delta)
	
#endregion
#region Custom Methods:
func makePath():
	if navAgent.target_position != get_tree().get_first_node_in_group("Player").position:
		navAgent.target_position = get_tree().get_first_node_in_group("Player").position
	
	#for curPoint in navAgent.get_current_navigation_path():
		#
		#var tileCoord = floorTilemap.local_to_map(floorTilemap.to_local(curPoint))
		#prints(tileCoord, " - ", curPoint)
		#if obstacles.get_used_cells().has(tileCoord):
			#print("true")
			#floorTilemap.get_cell_tile_data(tileCoord).set_navigation_polygon(0, null)
## Basic move-to-player function for enemies.

func basicMoving(delta):
	if !navAgent.is_target_reached():
		move_to(navAgent.get_next_path_position(), delta)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	handlePush()
	
func updateHealth():
	$EnemyComponents/HealthBar.value = health
	$EnemyComponents/HealthBar.max_value = maximumHealth
	$EnemyComponents/HealthBar.position.y = sprite.position.y + 11
func continousDamage(delta):
	for x in hurtBox.get_overlapping_areas():
		var parent : Node = x.get_parent()
		if parent is Character and parent.is_in_group("Friendly"):
			parent.health -= strength
		
#endregion
#region Signal:

func areaEntered(area : Area2D):
	
	var parent : Node = area.get_parent()
	if parent is Character and parent.is_in_group("Friendly"):
		parent.applyKnockback((area.global_position - global_position).normalized(), 250.0, 0.12)
	if parent is Weapon :
		enemy_hit.emit()
		applyKnockback((global_position - area.global_position).normalized(), 250.0, 0.12)
	if parent is Projectile:
			enemy_hit.emit()
			pass
	if parent is Weapon:
			self.health -= parent.strength
