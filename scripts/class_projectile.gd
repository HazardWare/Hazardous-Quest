class_name Projectile
extends Area2D
## What do you think they are? They're projectiles, okay.
##
## All which moves and has the possibility of interacting with other bodies.

@export var damage : int = 0
@export var speed := 750

# Godot functions:

func _ready() -> void:
	self.body_entered.connect(on_touch_body)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

# Signals:

func on_touch_body(body: Node2D):
	pass

# Custom Methods:
