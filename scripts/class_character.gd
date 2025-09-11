class_name Character
extends CharacterBody2D
## All who can be damaged.
##
## Provides ample foundation for any character in this game.

signal onDeath ## Emitted when health and blue hearts == 0.  
signal onHeal(amount:int) ## Emitted on a positive increase on health.
signal onDamaged(amount:int) ## Emitted on a negative decrease on health.

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
@export var shouldBleed : bool = true
@export var sprite : AnimatedSprite2D 
var knockback := Vector2.ZERO
var knockbackTimer := 0.0

## PushForce
@export var push_force := 5.0
@export var friction := 8.0
@export var acceleration := 5.0
@export var knockbackResistance := 0.0
## Current red hearts.
@onready var redHealth : int = maximumHealth :
	set(value):
		
		redHealth = setRedHealth(value)
	get:
		return redHealth
## Curent overall combined health. For healing, preferably use [member Character.redHealth] / [member Character.blueHealth] 
@onready var health : int = maximumHealth :
	set(value):
		var _prev = health
		health = setHealth(value)
		
		# Hurt
		if _prev > health :
			
			iFraming = true
			
			if shouldBleed:
				var currentParticle = $CharacterComponents/BloodParticles.duplicate()
				currentParticle.emitting = true
				add_child(currentParticle)
				
			$CharacterComponents/DamageAnimation.stop()
			$CharacterComponents/DamageAnimation.play("damaged")
			
			onDamaged.emit(health-value)
			# Dead 
			if health == 0:
				onDeath.emit()
				var curAudio = $CharacterComponents/Death.duplicate()
				get_parent().add_child(curAudio)
				curAudio.play()
				die()
			else:
				$CharacterComponents/Hit.pitch_scale = randf_range(0.8,1.2)
				$CharacterComponents/Hit.play()
		# Healed
		elif _prev < health:
			
			if shouldBleed:
				var currentParticle = $CharacterComponents/HealthParticles.duplicate()
				currentParticle.emitting = true
				add_child(currentParticle)
			
			$CharacterComponents/DamageAnimation.stop()
			$CharacterComponents/DamageAnimation.play("heal")
			
			onHeal.emit(health-value)
		
	get:
		return redHealth + blueHealth
		
		
## How much time [i] (in seconds, don't be fooled) [/i] should the character be invulnerable after just getting hit.
@export var iFrames : float = 0
var iFraming : bool : ## Temporarily invulnerable due to being hit.
	set(s):
		if !s:
			$CharacterComponents/iFrameTimer.stop()
			$CharacterComponents/iFrameBlinker.stop()
			return
		
		if !iFraming:
			$CharacterComponents/iFrameTimer.start(iFrames)
			$CharacterComponents/iFrameBlinker.start()
	get():
		return bool($CharacterComponents/iFrameTimer.time_left) 
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
	
func _physics_process(delta: float) -> void:
	characterProcess(delta)

func characterProcess(delta):
	handleKnockback(delta)
	
	if !iFraming and $CharacterComponents/iFrameBlinker.time_left != 0.0:
		$CharacterComponents/iFrameBlinker.stop()
		sprite.visible = true

func handleKnockback(delta):
	if knockbackTimer > 0.0:
		velocity = knockback
		knockbackTimer -= delta
		if knockbackTimer <= 0.0:
			knockback = Vector2.ZERO
	
func die():
	$CharacterComponents/DamageAnimation.play("die")
	var currentParticle = $CharacterComponents/BloodParticles.duplicate()
	currentParticle.emitting = true
	currentParticle.global_position = global_position
	get_parent().add_child(currentParticle)
	queue_free()

## Handles overall healing and damaging
func setHealth(value : int) -> int :
	value = max(value,0)
	
	if ( value == health ):
		return value

	# Damaged
	if( value < health ): 	
		# Deny damage when unable to be heart.
		if (shielding or iFraming or invulnerable):
			if shielding or invulnerable:
				$CharacterComponents/Shield.play()
				pass
			return health 

		
	

		# Make sure blue hearts are hit first.
		if ( value >= blueHealth ):
			redHealth = value - blueHealth
			blueHealth = 0
		else:
			blueHealth -= value 
	
	# Healed. Preferably don't heal HEALTH and instead either use redHealth or blueHealth
	if( value > health ):
		
		
		
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


## Handle pushing. Should be called after move_and_slide()
func handlePush():
	for id in get_slide_collision_count():
		var c = get_slide_collision(id)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

# Please please please type ts next time :). I'm slow and didn't know how to use this function - n
func applyKnockback(direction : Vector2, force : float, duration : float):
	knockback = direction * (force / ( knockbackResistance + 1.0 ) )
	knockbackTimer = duration
	
func move_to(pos, delta):
	
	var direction := global_position.direction_to(pos)
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, direction * speed, lerp_weight)
