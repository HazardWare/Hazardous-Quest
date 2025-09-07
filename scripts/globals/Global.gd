extends Node

@export var playerReference : Character :
	get():
		return get_tree().get_first_node_in_group("Player")
