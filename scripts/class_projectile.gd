@icon("res://assets/icons/icon_bullet.png")
class_name Projectile
extends CharacterBody2D
## What do you think they are? They're projectiles, okay.
##
## All which moves and has the possibility of interacting with other bodies.
## This uses CharacterBody2D, which seems counter-intuitive, but in reality is
## helpful for more reliable collision detection and movement.

## I'm sorry this script looks awful and is poorly documented.

@export var damage : int = 1
@export var speed := 350.0
@export var isFire := false

@export_subgroup("Linked nodes")
@export var sprite : AnimatedSprite2D
@export var collisionShape : CollisionShape2D 
@export var hurtBox : Area2D

@onready var bushTileMap : TileMapLayer = get_tree().get_first_node_in_group("BushLayer")

@onready var _speed := speed 
var lifetime := 0.0:
	set(val):
		if val >= MAXLIFETIME:
			queue_free()
		lifetime = val
		
		# fade out sprite
		#sprite.modulate.a = 1 - lifetime/MAXLIFETIME
		if(speed != 0.0):
			_speed = speed - (speed * (lifetime/MAXLIFETIME))
		else:
			_speed = max(_speed - 5.0,0)
const MAXLIFETIME := 1.0

## Initial velocity of the projectile.
## For reference, think of how tears move while you move in tboi,
## They tilt if you move. Behavior is replicated here, just a bit extreme.
var initial_velocity := Vector2.ZERO

#region Godot functions:

func _ready() -> void:
	hurtBox.body_entered.connect(on_touch_body)
#	$OffScreenDeleter.screen_exited.connect(queue_free)
	pass

func _physics_process(delta: float) -> void:
	# Move forward based on rotation.
	velocity = initial_velocity + (transform.x * _speed)
	# Face the direction of motion.
	if not isFire:
		if velocity:
			sprite.global_rotation = deg_to_rad(45.0) + velocity.angle()
			collisionShape.global_rotation = sprite.global_rotation
	elif isFire:
		lifetime += delta
		if snappedf(lifetime,0.05) == snappedf(lifetime,0.1):
			sprite.flip_h = !sprite.flip_h
		sprite.global_rotation = 0.0
		breakBushes()
	
	# Creates some pretty funny interactions:
		#rotation = velocity.angle()
	move_and_slide()

#endregion
#region Signals:

func on_touch_body(body: Node2D):
	print(body)
	speed = 0.0
	if not isFire:
		_speed = 0.0
	else:
		$SmokeParticles.emitting = true
	initial_velocity = Vector2.ZERO
	pass
#endregion
#region Custom Methods:
func breakBushes():
	var stoodOnTile : Vector2i = \
	bushTileMap.local_to_map(bushTileMap.to_local(global_position))
	if bushTileMap.get_cell_tile_data(stoodOnTile) and\
	bushTileMap.get_cell_tile_data(stoodOnTile).get_custom_data("bush"):
		bushTileMap.erase_cell(stoodOnTile)
		
#endregion
