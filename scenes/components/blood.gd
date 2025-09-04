extends CPUParticles2D

@export var isDead = false

func _ready() -> void:
	self.finished.connect(_on_finished)

func _on_finished() -> void:
	#if isDead: 
		queue_free()
