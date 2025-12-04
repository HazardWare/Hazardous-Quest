extends Area2D

@export_file("*.tscn") var toScene : String

@export var spawn_point_name : String

func _ready() -> void:
	body_entered.connect(switch)

var _ts_player
func switch(body: Node2D) -> void:
	if body is Player:
		_ts_player = body
		_ts_player.nextScene = toScene
		_ts_player.get_node("UIElements/SceneTransitionAnimation").play("fade_out")
		_ts_player.next_scene_spawn_point_name = spawn_point_name
