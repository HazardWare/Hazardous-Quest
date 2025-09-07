extends ProgressBar

var changeValueTween: Tween
var opacityTween: Tween

func _ready() -> void:
	self.value_changed.connect(_change_value)

func _change_value(newValue: float):
	value = newValue
	$HealthBar2.max_value = max_value
	if changeValueTween:
		changeValueTween.kill()
	changeValueTween = create_tween()
	changeValueTween.tween_property($HealthBar2, "value", newValue, 0.7)\
	.set_trans(Tween.TRANS_SINE)
