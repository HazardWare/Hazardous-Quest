extends Enemy

var direction := -1.0
var latched := false
@export_category("USE ME WITH AN ANIMATION PLAYER")
@export var _unused = "Read above"

func _ready() -> void:
	hurtBox.area_entered.connect(latch)

func _physics_process(delta: float) -> void:
	if latched:
		playerReference.global_position = global_position
	
func latch(area: Area2D):
	if area.get_parent() == playerReference:
		latched = true
	elif area.get_parent() is Weapon:
		latched = false
		playerReference.applyKnockback((area.global_position - global_position).normalized(), 250.0, 0.12)
