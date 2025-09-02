class_name Character
extends CharacterBody2D
## All who can be damaged.
##
## Provides ample foundation for any character in this game.

signal onDeath ## Emitted when health and blue hearts == 0.  
signal onHeal ## Emitted on a positive increase on health.
signal onDamaged ## Emitted on a negative decrease on health.

@export var maximumHealth : int = 10 ## Maximum health that this character starts at.
## Shielding hearts that go above red hearts.
@export var blueHealth : int = 0 :
	set(value):
		blueHealth = setBlueHealth(value)
	get:
		return blueHealth
@export var speed : float = 5000.0 ## Physical, in-world speed.
@export var strength : int = 1 ## Damage the character does.
@export var invulnerable : bool = false ## Unable to be damaged.
@export var toxic : bool = false ## Character inflicts poison.

## How much time [i] (in seconds, don't be fooled) [/i] should the character be invulnerable after just getting hit.
@export var iFrames : float = 0

## Current red hearts.
@onready var redHealth : int = maximumHealth :
	set(value):
		redHealth = setRedHealth(value)
	get:
		return redHealth
## Curent overall combined health. For healing, preferably use [member Character.redHealth] / [member Character.blueHealth] 
@onready var health : int = maximumHealth :
	set(value):
		health = setHealth(value)
		
		
	get:
		return redHealth + blueHealth
var iFraming : bool = false ## Temporarily invulnerable due to being hit.
var stunned : bool = false ## Stunned via something that stuns.
var shielding : bool = false ## Invulnerable(?) due to defending via shield.
var poisonDuration : float = 0 ## (Seconds) If above zero, character takes damage on an interval until poison duration runs out.
var poisoned : bool : ## Getter/Setter for evauluating if the character is poisoned
	get:
		return poisonDuration > 0
	set(value):
		if value:
			poisonDuration += 5

var characterComponent = preload("res://scenes/components/CharacterComponents.tscn")

#### Methods
#### Remember you can use SUPER to inherit functions.
func _ready() -> void:
	add_child(characterComponent.instantiate())

## Handles overall healing and damaging
func setHealth(value : int) -> int :
	
	if ( value == health ):
		# ???
		return value

	# Damaged
	if( value < health ): 	
		# Deny damage when unable to be heart.
		if (shielding or iFraming or invulnerable):
			return health 

		onDamaged.emit(health-value)
		var currentParticle = $CharacterComponents/BloodParticles.duplicate()
		currentParticle.emitting = true
		add_child(currentParticle)
	

		# Make sure blue hearts are hit first.
		if ( value >= blueHealth ):
			redHealth = value - blueHealth
			blueHealth = 0
		else:
			blueHealth -= value 
	
	# Healed. Preferably don't heal HEALTH and instead either use redHealth or blueHealth
	if( value > health ):
		onHeal.emit()
		if( value >= maximumHealth ):
			redHealth = maximumHealth
			blueHealth = value - maximumHealth
		else:
			redHealth = value
	
	return max(value, 0)

func setRedHealth(value : int) -> int:
	return clamp(value, 0, maximumHealth)

func setBlueHealth(value : int) -> int:
	return max(value, 0)
