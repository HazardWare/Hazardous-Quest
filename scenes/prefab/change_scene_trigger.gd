extends Area2D

@export_file("*.tscn") var toScene : String

func _ready() -> void:
	body_entered.connect(switch)


func switch(body: Node2D) -> void:
	if body == get_tree().get_first_node_in_group("Player"):
		body.nextScene = toScene
		body.get_node("UIElements/SceneTransitionAnimation").play("fade_out")
