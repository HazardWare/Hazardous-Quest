extends Interactable
class_name Door

@export var one : bool # Single door if true, double door if false
@export var open : bool



func _ready() -> void:
	if one:
		$InteractableArea.scale.x = 1
		$StaticBody2D/CollisionShape2D.scale.x = 1
		$Sprite2D.animation = "one"
	else:
		$InteractableArea.scale.x = 2.6
		$StaticBody2D/CollisionShape2D.scale.x = 2.6
		$Sprite2D.animation = "two"
	
	if open:
		$Sprite2D.frame = 2
	else:
		$Sprite2D.frame = 0

func _process(delta: float) -> void:
	super(delta)
	print(Global.inventory.bsearch("Key", true))
	
	if open:
		$StaticBody2D/CollisionShape2D.disabled = true
	else:
		$StaticBody2D/CollisionShape2D.disabled = false
