extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sophie/Anim.play("Sophie")
	$Noah/Anim.play("Noah")
	$Adair/Anim.play("Adair")
	$Max/Anim.play("Max")
	$Harper/Anim.play("Harper")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
