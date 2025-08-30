@icon("res://assets/icons/icon_bullet.png")
class_name Projectile
extends CharacterBody2D
## What do you think they are? They're projectiles, okay.
##
## All which moves and has the possibility of interacting with other bodies.
## This uses CharacterBody2D, which seems counter-intuitive, but in reality is
## helpful for more reliable collision detection and movement.

@export var damage : int = 1
@export var speed := 350

@export_subgroup("Linked nodes")
@export var sprite : AnimatedSprite2D
@export var collisionShape : CollisionShape2D 

## Initial velocity of the projectile.
## For reference, think of how tears move while you move in tboi,
## They tilt if you move. Behavior is replicated here, just a bit extreme.
var initial_velocity = Vector2.ZERO

# Godot functions:

func _ready() -> void:
	#self.body_entered.connect(on_touch_body)
	pass

func _physics_process(delta: float) -> void:
	# Move forward based on rotation.
	velocity = initial_velocity + (transform.x * speed)
	# Face the direction of motion.
	sprite.global_rotation = deg_to_rad(45.0) + velocity.angle()
	collisionShape.global_rotation = sprite.global_rotation
	
	# Creates some pretty funny interactions:
	#rotation = velocity.angle()
	move_and_slide()

# Signals:

func on_touch_body(body: Node2D):
	#queue_free()
	pass

# Custom Methods:
