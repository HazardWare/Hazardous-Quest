extends VisibleOnScreenNotifier2D
## Automatically deletes the parent when this box is offscreen.
func _ready() -> void:
	self.screen_exited.connect(get_parent().queue_free)
	pass
