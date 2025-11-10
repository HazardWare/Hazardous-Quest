extends Node2D


@export var loaded_level : PackedScene

func _ready() -> void:
	reload_map()

func reload_map() -> void:
	
	if !$Level:
		push_error("Add level scene bruh")
		return
		
	if !$Level.get_child_count() == 0:
		push_warning("No level specified to load. Give me a level!")
	
	# Eliminate $Level's children. It should only be one scence, but you can NEVER be too careful.
	for i in $Level.get_children(): i.queue_free()
	
	# Impregnate the level scene.
	$Level.add_child(loaded_level.instantiate())
