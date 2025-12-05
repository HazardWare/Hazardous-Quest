extends Pickups

@export var halfHeart: bool
# Half heart if true, full heart if false



func _ready() -> void:
	if halfHeart:
		$AnimatedSprite2D.play("half")
	else:
		$AnimatedSprite2D.play("full")

func _process(delta: float) -> void:
	super(delta)
	if touchingPlayer:
		if halfHeart:
			Global.playerReference.redHealth += 1
		else:
			Global.playerReference.redHealth += 2
		queue_free()
