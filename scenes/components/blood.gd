extends CPUParticles2D

@export var isDead = false

func _on_finished() -> void:
	#if isDead: 
		queue_free()
