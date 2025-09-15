extends Enemy

func _ready() -> void:
	hurtBox.area_entered.connect(handleKnockbackAndDamage)
func _physics_process(delta: float) -> void:
	continousDamage(delta)

func handleKnockbackAndDamage(area):
	var parent : Node = area.get_parent()
	if parent is Character and parent.is_in_group("Friendly"):
		parent.applyKnockback((area.global_position - global_position).normalized(), 500.0, 0.12)
