@icon("res://assets/icons/icon_sword.png")
class_name Weapon
extends AnimatedSprite2D

@export var friendly := true
@export var strength := 1

func _ready():
	self.visibility_changed.connect(updateDamageBox)
	updateDamageBox()
	
func updateDamageBox():
	$DamageBox.process_mode = Node.PROCESS_MODE_DISABLED if !visible else Node.PROCESS_MODE_INHERIT
